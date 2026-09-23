import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Repositorio relacional para la gestión de la Estructura Organizacional de RRHH:
/// Áreas / Departamentos, Cargos / Puestos de Trabajo y Especialidades Técnicas.
class RrhhOrganizationRepository {
  final Session session;

  const RrhhOrganizationRepository(this.session);

  // ===========================================================================
  // 1. ÁREAS / DEPARTAMENTOS ORGANIZACIONALES
  // ===========================================================================

  /// Lista las áreas de la empresa, opcionalmente filtrando por activas o búsqueda.
  Future<List<RrhhArea>> listAreas({
    bool includeInactive = false,
    String? search,
  }) async {
    return await RrhhArea.db.find(
      session,
      where: (t) {
        var expr = t.isDeleted.equals(false);
        if (!includeInactive) {
          expr = expr & t.isActive.equals(true);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr = expr & (t.name.ilike(query) | t.code.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.name,
    );
  }

  /// Obtiene un área por su identificador primario.
  Future<RrhhArea?> getAreaById(int id, {bool includeDeleted = false}) async {
    return await RrhhArea.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(id) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
  }

  /// Crea una nueva área validando unicidad de código y nombre.
  Future<RrhhArea> createArea(RrhhArea area) async {
    final cleanCode = area.code.trim().toUpperCase();
    final cleanName = area.name.trim();

    final existingCode = await RrhhArea.db.findFirstRow(
      session,
      where: (t) => t.code.equals(cleanCode),
    );
    if (existingCode != null) {
      throw FormatException(
        'El código de área "$cleanCode" ya se encuentra registrado.',
      );
    }

    final existingName = await RrhhArea.db.findFirstRow(
      session,
      where: (t) => t.name.ilike(cleanName),
    );
    if (existingName != null) {
      throw FormatException(
        'Ya existe un departamento registrado con el nombre "$cleanName".',
      );
    }

    final now = DateTime.now().toUtc();
    final toInsert = area.copyWith(
      code: cleanCode,
      name: cleanName,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await RrhhArea.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos de un área existente.
  Future<RrhhArea> updateArea(RrhhArea area) async {
    final existing = await getAreaById(area.id!);
    if (existing == null) {
      throw FormatException('El área solicitada no existe.');
    }

    final cleanName = area.name.trim();
    if (cleanName.toLowerCase() != existing.name.toLowerCase()) {
      final duplicate = await RrhhArea.db.findFirstRow(
        session,
        where: (t) => t.name.ilike(cleanName) & t.id.notEquals(area.id!),
      );
      if (duplicate != null) {
        throw FormatException(
          'Ya existe otro departamento con el nombre "$cleanName".',
        );
      }
    }

    final now = DateTime.now().toUtc();
    final toUpdate = area.copyWith(
      name: cleanName,
      updatedAt: now,
    );

    return await RrhhArea.db.updateRow(session, toUpdate);
  }

  /// Soft delete de un área y desactivación en cascada de sus cargos asociados.
  Future<bool> deleteArea(int id) async {
    final existing = await getAreaById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhArea.db.updateRow(
      session,
      existing.copyWith(
        isActive: false,
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );

    // Cascada lógica sobre cargos dependientes de esta área
    final linkedPositions = await RrhhPosition.db.find(
      session,
      where: (t) => t.areaId.equals(id) & t.isDeleted.equals(false),
    );
    for (final pos in linkedPositions) {
      await RrhhPosition.db.updateRow(
        session,
        pos.copyWith(
          isActive: false,
          isDeleted: true,
          deletedAt: now,
          updatedAt: now,
        ),
      );
    }

    return true;
  }

  // ===========================================================================
  // 2. CARGOS / PUESTOS DE TRABAJO
  // ===========================================================================

  /// Lista los cargos organizacionales, con filtros por área, tipo ('Oficina'/'Campo') y búsqueda.
  Future<List<RrhhPosition>> listPositions({
    int? areaId,
    String? workplaceType,
    bool includeInactive = false,
    String? search,
  }) async {
    return await RrhhPosition.db.find(
      session,
      where: (t) {
        var expr = t.isDeleted.equals(false);
        if (areaId != null) {
          expr = expr & t.areaId.equals(areaId);
        }
        if (workplaceType != null && workplaceType.trim().isNotEmpty) {
          expr = expr & t.workplaceType.equals(workplaceType.trim());
        }
        if (!includeInactive) {
          expr = expr & t.isActive.equals(true);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr = expr & (t.name.ilike(query) | t.code.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.name,
    );
  }

  /// Obtiene un cargo por su identificador primario.
  Future<RrhhPosition?> getPositionById(
    int id, {
    bool includeDeleted = false,
  }) async {
    return await RrhhPosition.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(id) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
  }

  /// Crea un nuevo cargo validando existencia del área y unicidad de nombre en la misma.
  Future<RrhhPosition> createPosition(RrhhPosition position) async {
    final area = await getAreaById(position.areaId);
    if (area == null) {
      throw FormatException(
        'El área especificada no existe o fue dada de baja.',
      );
    }

    final cleanCode = position.code.trim().toUpperCase();
    final cleanName = position.name.trim();

    final existingCode = await RrhhPosition.db.findFirstRow(
      session,
      where: (t) => t.code.equals(cleanCode),
    );
    if (existingCode != null) {
      throw FormatException(
        'El código de cargo "$cleanCode" ya se encuentra registrado.',
      );
    }

    final existingInArea = await RrhhPosition.db.findFirstRow(
      session,
      where: (t) =>
          t.areaId.equals(position.areaId) &
          t.name.ilike(cleanName) &
          t.isDeleted.equals(false),
    );
    if (existingInArea != null) {
      throw FormatException(
        'Ya existe un cargo registrado como "$cleanName" dentro del área ${area.name}.',
      );
    }

    final now = DateTime.now().toUtc();
    final toInsert = position.copyWith(
      code: cleanCode,
      name: cleanName,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await RrhhPosition.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos de un cargo existente.
  Future<RrhhPosition> updatePosition(RrhhPosition position) async {
    final existing = await getPositionById(position.id!);
    if (existing == null) {
      throw FormatException('El cargo solicitado no existe.');
    }

    final cleanName = position.name.trim();
    if (cleanName.toLowerCase() != existing.name.toLowerCase() ||
        position.areaId != existing.areaId) {
      final duplicate = await RrhhPosition.db.findFirstRow(
        session,
        where: (t) =>
            t.areaId.equals(position.areaId) &
            t.name.ilike(cleanName) &
            t.id.notEquals(position.id!) &
            t.isDeleted.equals(false),
      );
      if (duplicate != null) {
        throw FormatException(
          'Ya existe otro cargo con el nombre "$cleanName" en el área especificada.',
        );
      }
    }

    final now = DateTime.now().toUtc();
    final toUpdate = position.copyWith(
      name: cleanName,
      updatedAt: now,
    );

    return await RrhhPosition.db.updateRow(session, toUpdate);
  }

  /// Soft delete de un cargo.
  Future<bool> deletePosition(int id) async {
    final existing = await getPositionById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhPosition.db.updateRow(
      session,
      existing.copyWith(
        isActive: false,
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );

    return true;
  }

  // ===========================================================================
  // 3. ESPECIALIDADES TÉCNICAS Y OPERATIVAS
  // ===========================================================================

  /// Lista las especialidades técnicas para personal de campo y operativo.
  Future<List<RrhhSpecialty>> listSpecialties({
    bool includeInactive = false,
    String? search,
  }) async {
    return await RrhhSpecialty.db.find(
      session,
      where: (t) {
        var expr = t.isDeleted.equals(false);
        if (!includeInactive) {
          expr = expr & t.isActive.equals(true);
        }
        if (search != null && search.trim().isNotEmpty) {
          final query = '%${search.trim()}%';
          expr = expr & (t.name.ilike(query) | t.code.ilike(query));
        }
        return expr;
      },
      orderBy: (t) => t.name,
    );
  }

  /// Obtiene una especialidad por su identificador primario.
  Future<RrhhSpecialty?> getSpecialtyById(
    int id, {
    bool includeDeleted = false,
  }) async {
    return await RrhhSpecialty.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(id) &
          (includeDeleted ? Constant.bool(true) : t.isDeleted.equals(false)),
    );
  }

  /// Crea una nueva especialidad operativa validando unicidad de código y nombre.
  Future<RrhhSpecialty> createSpecialty(RrhhSpecialty specialty) async {
    final cleanCode = specialty.code.trim().toUpperCase();
    final cleanName = specialty.name.trim();

    final existingCode = await RrhhSpecialty.db.findFirstRow(
      session,
      where: (t) => t.code.equals(cleanCode),
    );
    if (existingCode != null) {
      throw FormatException(
        'El código de especialidad "$cleanCode" ya se encuentra registrado.',
      );
    }

    final existingName = await RrhhSpecialty.db.findFirstRow(
      session,
      where: (t) => t.name.ilike(cleanName),
    );
    if (existingName != null) {
      throw FormatException(
        'Ya existe una especialidad registrada con el nombre "$cleanName".',
      );
    }

    final now = DateTime.now().toUtc();
    final toInsert = specialty.copyWith(
      code: cleanCode,
      name: cleanName,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await RrhhSpecialty.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos de una especialidad existente.
  Future<RrhhSpecialty> updateSpecialty(RrhhSpecialty specialty) async {
    final existing = await getSpecialtyById(specialty.id!);
    if (existing == null) {
      throw FormatException('La especialidad solicitada no existe.');
    }

    final cleanName = specialty.name.trim();
    if (cleanName.toLowerCase() != existing.name.toLowerCase()) {
      final duplicate = await RrhhSpecialty.db.findFirstRow(
        session,
        where: (t) => t.name.ilike(cleanName) & t.id.notEquals(specialty.id!),
      );
      if (duplicate != null) {
        throw FormatException(
          'Ya existe otra especialidad con el nombre "$cleanName".',
        );
      }
    }

    final now = DateTime.now().toUtc();
    final toUpdate = specialty.copyWith(
      name: cleanName,
      updatedAt: now,
    );

    return await RrhhSpecialty.db.updateRow(session, toUpdate);
  }

  /// Soft delete de una especialidad.
  Future<bool> deleteSpecialty(int id) async {
    final existing = await getSpecialtyById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await RrhhSpecialty.db.updateRow(
      session,
      existing.copyWith(
        isActive: false,
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );

    return true;
  }

  // ===========================================================================
  // 4. SEEDER DE INICIALIZACIÓN ORGANIZACIONAL
  // ===========================================================================

  /// Inicializa los catálogos organizacionales base si las tablas se encuentran vacías.
  Future<void> seedInitialOrganizationData() async {
    final areasCount = await RrhhArea.db.count(session);
    if (areasCount > 0) return;

    final now = DateTime.now().toUtc();

    // 1. Áreas
    final areaOps = await RrhhArea.db.insertRow(
      session,
      RrhhArea(
        code: 'AREA-OPER',
        name: 'Operaciones',
        description:
            'Gestión de personal operativo en campo y servicios a clientes.',
        colorTag: '#10B981',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final areaRrhh = await RrhhArea.db.insertRow(
      session,
      RrhhArea(
        code: 'AREA-RRHH',
        name: 'Recursos Humanos',
        description:
            'Administración del personal, contrataciones y bienestar laboral.',
        colorTag: '#6366F1',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final areaAdm = await RrhhArea.db.insertRow(
      session,
      RrhhArea(
        code: 'AREA-ADM',
        name: 'Administración y Finanzas',
        description:
            'Contabilidad, facturación, compras y finanzas corporativas.',
        colorTag: '#F59E0B',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final areaCom = await RrhhArea.db.insertRow(
      session,
      RrhhArea(
        code: 'AREA-COM',
        name: 'Comercial & Marketing',
        description:
            'Prospección, ventas corporativas y relación con clientes CRM.',
        colorTag: '#EC4899',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 2. Cargos
    final defaultPositions = [
      // Operaciones (Campo)
      RrhhPosition(
        code: 'CARGO-JARD',
        areaId: areaOps.id!,
        name: 'Jardinero',
        workplaceType: 'Campo',
        suggestedSalary: 2500.0,
        description: 'Mantenimiento de áreas verdes y jardines corporativos.',
        requirements:
            'Experiencia en podado, riego y maquinaria de jardinería.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhPosition(
        code: 'CARGO-OPER-LIMP',
        areaId: areaOps.id!,
        name: 'Operario de Limpieza',
        workplaceType: 'Campo',
        suggestedSalary: 2500.0,
        description:
            'Limpieza institucional, desinfección y mantenimiento de ambientes.',
        requirements:
            'Conocimiento de protocolos de bioseguridad y químicos de limpieza.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhPosition(
        code: 'CARGO-GUARD-SEG',
        areaId: areaOps.id!,
        name: 'Guardia de Seguridad',
        workplaceType: 'Campo',
        suggestedSalary: 2800.0,
        description:
            'Vigilancia física, control de accesos y rondas preventivas.',
        requirements:
            'Libreta de servicio militar y certificado de antecedentes.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhPosition(
        code: 'CARGO-TEC-MANT',
        areaId: areaOps.id!,
        name: 'Técnico de Mantenimiento',
        workplaceType: 'Campo',
        suggestedSalary: 3200.0,
        description:
            'Mantenimiento preventivo y correctivo eléctrico y de bombas.',
        requirements: 'Formación técnica en electricidad o electromecánica.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      // RRHH (Oficina)
      RrhhPosition(
        code: 'CARGO-ENC-RRHH',
        areaId: areaRrhh.id!,
        name: 'Encargada de Recursos Humanos',
        workplaceType: 'Oficina',
        suggestedSalary: 4500.0,
        description: 'Gestión integral del talento, contratos y clima laboral.',
        requirements: 'Licenciatura en Psicología, Administración o RRHH.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      // Administración (Oficina)
      RrhhPosition(
        code: 'CARGO-CONT-GEN',
        areaId: areaAdm.id!,
        name: 'Contador General',
        workplaceType: 'Oficina',
        suggestedSalary: 5000.0,
        description:
            'Libros oficiales, balances contables y liquidación impositiva.',
        requirements: 'Título en Provisión Nacional de Contador Público.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      // Comercial (Oficina)
      RrhhPosition(
        code: 'CARGO-EJEC-VENT',
        areaId: areaCom.id!,
        name: 'Ejecutivo Comercial',
        workplaceType: 'Oficina',
        suggestedSalary: 3500.0,
        description:
            'Prospección comercial B2B, cotizaciones y cierre de contratos.',
        requirements: 'Experiencia previa en ventas corporativas de servicios.',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final pos in defaultPositions) {
      await RrhhPosition.db.insertRow(session, pos);
    }

    // 3. Especialidades
    final defaultSpecialties = [
      RrhhSpecialty(
        code: 'ESP-JARD',
        name: 'Jardinería & Paisajismo',
        description:
            'Poda técnica, tratamiento fitosanitario y diseño paisajístico.',
        colorTag: '#10B981',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhSpecialty(
        code: 'ESP-LIMP',
        name: 'Limpieza e Higiene Hospitalaria/Industrial',
        description:
            'Técnicas de desinfección profunda y manejo de residuos biológicos.',
        colorTag: '#3B82F6',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhSpecialty(
        code: 'ESP-SEG',
        name: 'Seguridad Física & CCTV',
        description:
            'Monitoreo de cámaras, control perimetral y primeros auxilios.',
        colorTag: '#EF4444',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhSpecialty(
        code: 'ESP-MANT',
        name: 'Mantenimiento Electromecánico',
        description:
            'Instalaciones eléctricas industriales, tableros y sistemas hidroneumáticos.',
        colorTag: '#F59E0B',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
      RrhhSpecialty(
        code: 'ESP-CLIM',
        name: 'Climatización y HVAC',
        description:
            'Mantenimiento preventivo de aires acondicionados centrales y splits.',
        colorTag: '#8B5CF6',
        isActive: true,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final spec in defaultSpecialties) {
      await RrhhSpecialty.db.insertRow(session, spec);
    }
  }
}
