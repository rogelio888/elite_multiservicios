import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Repositorio para la gestión de candidatos / postulantes en el embudo de selección de RRHH.
class RrhhRecruitmentRepository {
  final Session session;

  const RrhhRecruitmentRepository(this.session);

  /// Lista postulantes con filtros avanzados y paginación.
  Future<List<RrhhApplicant>> listApplicants({
    String? status,
    String? targetType,
    int? specialtyId,
    String? search,
    int limit = 50,
    int offset = 0,
    bool includeDeleted = false,
  }) async {
    return await RrhhApplicant.db.find(
      session,
      where: (t) {
        var expr = includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false);
        if (status != null && status.trim().isNotEmpty) {
          expr = expr & t.status.equals(status.trim().toUpperCase());
        }
        if (targetType != null && targetType.trim().isNotEmpty) {
          expr = expr & t.targetType.equals(targetType.trim().toUpperCase());
        }
        if (specialtyId != null) {
          expr = expr & t.specialtyId.equals(specialtyId);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr = expr &
              (t.fullName.ilike(query) |
                  t.identityCard.ilike(query) |
                  t.code.ilike(query) |
                  t.targetPosition.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }

  /// Obtiene un postulante por su ID.
  Future<RrhhApplicant?> getApplicantById(
    int id, {
    bool includeDeleted = false,
  }) async {
    return await RrhhApplicant.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(id) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
  }

  /// Obtiene un postulante por su código identificador (ej: POST-001).
  Future<RrhhApplicant?> getApplicantByCode(
    String code, {
    bool includeDeleted = false,
  }) async {
    return await RrhhApplicant.db.findFirstRow(
      session,
      where: (t) =>
          t.code.equals(code.trim().toUpperCase()) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
  }

  /// Crea un nuevo postulante con generación secuencial de código (POST-001, POST-002, etc.).
  Future<RrhhApplicant> createApplicant(RrhhApplicant applicant) async {
    final cleanFullName = applicant.fullName.trim();
    final cleanCi = applicant.identityCard.trim();
    final cleanPhone = applicant.phone.trim();

    if (cleanFullName.isEmpty) {
      throw FormatException('El nombre completo del postulante es obligatorio.');
    }
    if (cleanCi.isEmpty) {
      throw FormatException('El documento de identidad (CI) es obligatorio.');
    }
    if (cleanPhone.isEmpty) {
      throw FormatException('El teléfono de contacto es obligatorio.');
    }

    String generatedCode = applicant.code.trim().toUpperCase();
    if (generatedCode.isEmpty || generatedCode == 'AUTO' || generatedCode == 'POST-') {
      final totalCount = await RrhhApplicant.db.count(session);
      generatedCode = 'POST-${(totalCount + 1).toString().padLeft(3, '0')}';

      // Verificar que no colisione
      var existingWithCode = await getApplicantByCode(generatedCode, includeDeleted: true);
      int counter = totalCount + 1;
      while (existingWithCode != null) {
        counter++;
        generatedCode = 'POST-${counter.toString().padLeft(3, '0')}';
        existingWithCode = await getApplicantByCode(generatedCode, includeDeleted: true);
      }
    } else {
      final duplicate = await getApplicantByCode(generatedCode, includeDeleted: true);
      if (duplicate != null) {
        throw FormatException('El código "$generatedCode" ya se encuentra registrado.');
      }
    }

    final now = DateTime.now().toUtc();
    final toInsert = applicant.copyWith(
      code: generatedCode,
      fullName: cleanFullName,
      identityCard: cleanCi,
      phone: cleanPhone,
      targetType: applicant.targetType.trim().toUpperCase(),
      status: applicant.status.trim().toUpperCase(),
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await RrhhApplicant.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos de un postulante existente.
  Future<RrhhApplicant> updateApplicant(RrhhApplicant applicant) async {
    final existing = await getApplicantById(applicant.id!);
    if (existing == null) {
      throw FormatException('El postulante solicitado no existe.');
    }

    final now = DateTime.now().toUtc();
    final toUpdate = applicant.copyWith(
      fullName: applicant.fullName.trim(),
      identityCard: applicant.identityCard.trim(),
      phone: applicant.phone.trim(),
      targetType: applicant.targetType.trim().toUpperCase(),
      status: applicant.status.trim().toUpperCase(),
      updatedAt: now,
    );

    return await RrhhApplicant.db.updateRow(session, toUpdate);
  }

  /// Actualiza el estado del postulante dentro del pipeline de selección.
  Future<RrhhApplicant> updateApplicantStatus(
    int id, {
    required String newStatus,
    String? interviewNotes,
    String? discardReason,
  }) async {
    final existing = await getApplicantById(id);
    if (existing == null) {
      throw FormatException('El postulante solicitado no existe.');
    }

    final validStatuses = [
      'NUEVO',
      'EN_EVALUACION',
      'ENTREVISTADO',
      'SELECCIONADO',
      'RECHAZADO',
      'CONTRATADO',
    ];

    final normalized = newStatus.trim().toUpperCase();
    if (!validStatuses.contains(normalized)) {
      throw FormatException(
        'Estado inválido: "$newStatus". Estados permitidos: ${validStatuses.join(", ")}',
      );
    }

    final now = DateTime.now().toUtc();
    final toUpdate = existing.copyWith(
      status: normalized,
      interviewNotes: interviewNotes ?? existing.interviewNotes,
      discardReason: discardReason ?? existing.discardReason,
      updatedAt: now,
    );

    return await RrhhApplicant.db.updateRow(session, toUpdate);
  }

  /// Soft delete de un postulante.
  Future<bool> deleteApplicant(int id) async {
    final existing = await getApplicantById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhApplicant.db.updateRow(
      session,
      existing.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );

    return true;
  }

  /// Sembrado inicial de postulantes si la tabla se encuentra vacía.
  Future<void> seedInitialApplicants() async {
    final count = await RrhhApplicant.db.count(session);
    if (count > 0) return;

    final now = DateTime.now().toUtc();

    final defaultApplicants = [
      RrhhApplicant(
        code: 'POST-001',
        fullName: 'Alejandro Morales Villarroel',
        identityCard: '9123841 SCZ',
        phone: '+591 75019284',
        email: 'alejandro.morales.post@gmail.com',
        address: 'Plan 3000, Barrio Guapurú Calle 12',
        birthDate: DateTime.utc(1997, 5, 12),
        emergencyContact: 'Teresa Villarroel (Madre)',
        emergencyPhone: '+591 75099881',
        targetArea: 'Operaciones',
        targetPosition: 'Técnico de Mantenimiento',
        targetType: 'CAMPO',
        specialty: 'Mantenimiento Electromecánico',
        education: 'Técnico Superior Electromecánico (INFOCAL)',
        experienceSummary: '2 años en mantenimiento de motobombas y tableros en condominios.',
        skills: 'Electricidad industrial, plomería, bombas sumergibles.',
        referencePerson: 'Ing. Carlos Justiniano (Ex-Jefe)',
        referencePhone: '+591 71329019',
        applicationDate: now.subtract(const Duration(days: 10)),
        status: 'SELECCIONADO',
        interviewNotes: 'Excelente predisposición técnica, antecedentes FELCC verificados limpios.',
        expectedSalary: 4500.0,
        hasCvAttached: true,
        hasIdentityCardCopy: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
      RrhhApplicant(
        code: 'POST-002',
        fullName: 'Beatriz Suárez Justiniano',
        identityCard: '8239102 SCZ',
        phone: '+591 78920194',
        email: 'beatriz.suarez.j@gmail.com',
        address: 'Villa 1ro de Mayo, Calle 7 #45',
        birthDate: DateTime.utc(1999, 8, 20),
        emergencyContact: 'Raúl Suárez (Padre)',
        emergencyPhone: '+591 78900199',
        targetArea: 'Comercial & Marketing',
        targetPosition: 'Ejecutivo Comercial',
        targetType: 'OFICINA',
        specialty: 'Comercial & Licitaciones',
        education: 'Lic. en Diseño Gráfico y Marketing (UPSA)',
        experienceSummary: '1 año en agencia de publicidad y captación de clientes.',
        skills: 'Branding B2B, edición de video corto, prospección comercial.',
        referencePerson: 'Lic. Sofía Arteaga',
        referencePhone: '+591 72199001',
        applicationDate: now.subtract(const Duration(days: 8)),
        status: 'EN_EVALUACION',
        interviewNotes: 'Entrevista técnica completada. Pendiente entrega de portafolio comercial.',
        expectedSalary: 4200.0,
        hasCvAttached: true,
        hasIdentityCardCopy: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now,
      ),
      RrhhApplicant(
        code: 'POST-003',
        fullName: 'Gonzalo Quispe Mamani',
        identityCard: '6829104 LPZ',
        phone: '+591 73491029',
        email: 'gonzalo.quispe.m@outlook.com',
        address: 'Barrio Los Lotes, Calle 3 #102',
        birthDate: DateTime.utc(1993, 11, 4),
        emergencyContact: 'Julia Mamani (Esposa)',
        emergencyPhone: '+591 73400192',
        targetArea: 'Operaciones',
        targetPosition: 'Jardinero',
        targetType: 'CAMPO',
        specialty: 'Jardinería & Paisajismo',
        education: 'Bachiller en Humanidades',
        experienceSummary: '3 años de experiencia en jardinería residencial y parques.',
        skills: 'Manejo de motoguadaña, diseño de setos, poda de palmeras.',
        referencePerson: 'José Luis Flores',
        referencePhone: '+591 76011239',
        applicationDate: now.subtract(const Duration(days: 5)),
        status: 'NUEVO',
        interviewNotes: 'Postulación recibida. Agendar primera entrevista presencial.',
        expectedSalary: 3500.0,
        hasCvAttached: true,
        hasIdentityCardCopy: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      RrhhApplicant(
        code: 'POST-004',
        fullName: 'Mario Centellas Barrientos',
        identityCard: '5910283 CBBA',
        phone: '+591 76901928',
        email: 'mario.centellas@gmail.com',
        address: 'Av. Santos Dumont 5to Anillo',
        birthDate: DateTime.utc(1990, 3, 18),
        emergencyContact: 'Ramiro Centellas (Hermano)',
        emergencyPhone: '+591 76900192',
        targetArea: 'Operaciones',
        targetPosition: 'Guardia de Seguridad',
        targetType: 'CAMPO',
        specialty: 'Seguridad Física & CCTV',
        education: 'Servicio Militar Cumplido',
        experienceSummary: '6 meses en seguridad privada en condominios.',
        skills: 'Vigilancia de garitas, rondas perimetrales.',
        referencePerson: 'Sgto. Alberto Paz',
        referencePhone: '+591 71099231',
        applicationDate: now.subtract(const Duration(days: 20)),
        status: 'RECHAZADO',
        interviewNotes: 'No presentó antecedentes FELCC actualizados en el plazo establecido.',
        discardReason: 'Falta de documentación requerida (antecedentes policiales).',
        expectedSalary: 3800.0,
        hasCvAttached: true,
        hasIdentityCardCopy: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
    ];

    for (final app in defaultApplicants) {
      await RrhhApplicant.db.insertRow(session, app);
    }
  }
}
