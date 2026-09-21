import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Repositorio relacional para la gestión integral del Catálogo de Servicios,
/// Tarifario Maestro, Rubros Industriales y Tarifas Diferenciadas (Scopes).
class CrmCatalogRepository {
  final Session session;

  const CrmCatalogRepository(this.session);

  // ===========================================================================
  // 1. SECTORES / RUBROS INDUSTRIALES
  // ===========================================================================

  /// Lista los sectores o rubros industriales no eliminados lógicamente.
  Future<List<CrmSector>> listSectors({bool includeInactive = false}) async {
    return await CrmSector.db.find(
      session,
      where: (t) =>
          t.isDeleted.equals(false) &
          (includeInactive ? Constant.bool(true) : t.isActive.equals(true)),
      orderBy: (t) => t.name,
    );
  }

  /// Obtiene un sector por su ID.
  Future<CrmSector?> getSectorById(int id) async {
    return await CrmSector.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Crea un nuevo sector industrial con validación de unicidad.
  Future<CrmSector> createSector(CrmSector sector) async {
    final cleanCode = sector.code.trim().toUpperCase();
    final cleanName = sector.name.trim();

    final existingCode = await CrmSector.db.findFirstRow(
      session,
      where: (t) => t.code.equals(cleanCode),
    );
    if (existingCode != null) {
      throw FormatException(
        'El código de sector "$cleanCode" ya se encuentra registrado.',
      );
    }

    final existingName = await CrmSector.db.findFirstRow(
      session,
      where: (t) => t.name.ilike(cleanName),
    );
    if (existingName != null) {
      throw FormatException(
        'Ya existe un rubro registrado con el nombre "$cleanName".',
      );
    }

    final now = DateTime.now().toUtc();
    final toInsert = sector.copyWith(
      code: cleanCode,
      name: cleanName,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmSector.db.insertRow(session, toInsert);
  }

  /// Actualiza un sector existente.
  Future<CrmSector> updateSector(CrmSector sector) async {
    final existing = await getSectorById(sector.id!);
    if (existing == null) {
      throw FormatException('El sector solicitado no existe.');
    }

    final toUpdate = sector.copyWith(updatedAt: DateTime.now().toUtc());
    return await CrmSector.db.updateRow(session, toUpdate);
  }

  /// Soft delete de sector con cascada lógica sobre sus scopes asociados.
  Future<bool> deleteSector(int id) async {
    final existing = await getSectorById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await CrmSector.db.updateRow(
      session,
      existing.copyWith(
        isActive: false,
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );

    // Cascada lógica: desactivar scopes vinculados a este sector
    final linkedScopes = await CrmCatalogItemScope.db.find(
      session,
      where: (t) => t.sectorId.equals(id) & t.isDeleted.equals(false),
    );

    for (final scope in linkedScopes) {
      await CrmCatalogItemScope.db.updateRow(
        session,
        scope.copyWith(
          isActive: false,
          isDeleted: true,
          updatedAt: now,
        ),
      );
    }

    return true;
  }

  // ===========================================================================
  // 2. LÍNEAS DE SERVICIO
  // ===========================================================================

  /// Lista las líneas de servicio registradas.
  Future<List<CrmServiceLine>> listServiceLines({
    String? category,
    bool includeInactive = false,
  }) async {
    return await CrmServiceLine.db.find(
      session,
      where: (t) =>
          t.isDeleted.equals(false) &
          (includeInactive ? Constant.bool(true) : t.isActive.equals(true)) &
          (category != null ? t.category.equals(category) : Constant.bool(true)),
      orderBy: (t) => t.name,
    );
  }

  /// Obtiene una línea de servicio por ID.
  Future<CrmServiceLine?> getServiceLineById(int id) async {
    return await CrmServiceLine.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Crea una nueva línea de servicio.
  Future<CrmServiceLine> createServiceLine(CrmServiceLine line) async {
    final cleanCode = line.code.trim().toUpperCase();
    final cleanName = line.name.trim();

    final existingCode = await CrmServiceLine.db.findFirstRow(
      session,
      where: (t) => t.code.equals(cleanCode),
    );
    if (existingCode != null) {
      throw FormatException(
        'El código de línea "$cleanCode" ya está registrado.',
      );
    }

    final now = DateTime.now().toUtc();
    final toInsert = line.copyWith(
      code: cleanCode,
      name: cleanName,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmServiceLine.db.insertRow(session, toInsert);
  }

  /// Actualiza una línea de servicio.
  Future<CrmServiceLine> updateServiceLine(CrmServiceLine line) async {
    final existing = await getServiceLineById(line.id!);
    if (existing == null) {
      throw FormatException('La línea de servicio solicitada no existe.');
    }

    final toUpdate = line.copyWith(updatedAt: DateTime.now().toUtc());
    return await CrmServiceLine.db.updateRow(session, toUpdate);
  }

  /// Soft delete de línea de servicio.
  Future<bool> deleteServiceLine(int id) async {
    final existing = await getServiceLineById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();
    await CrmServiceLine.db.updateRow(
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
  // 3. CATÁLOGO DE PARTIDAS Y TARIFARIO MAESTRO
  // ===========================================================================

  /// Lista partidas maestras, resolviendo opcionalmente overrides para un sector.
  Future<List<CrmCatalogItem>> listCatalogItems({
    String? category,
    int? sectorId,
    int? serviceLineId,
    bool activeOnly = true,
  }) async {
    final items = await CrmCatalogItem.db.find(
      session,
      where: (t) =>
          t.isDeleted.equals(false) &
          (activeOnly ? t.isActive.equals(true) : Constant.bool(true)) &
          (category != null ? t.category.equals(category) : Constant.bool(true)) &
          (serviceLineId != null
              ? t.serviceLineId.equals(serviceLineId)
              : Constant.bool(true)),
      orderBy: (t) => t.concept,
    );

    if (sectorId == null || items.isEmpty) {
      return items;
    }

    // Resolver overrides de precio y parámetros para el sector solicitado
    final scopes = await CrmCatalogItemScope.db.find(
      session,
      where: (t) =>
          t.sectorId.equals(sectorId) &
          t.isDeleted.equals(false) &
          t.isActive.equals(true),
    );

    final scopeByItemId = {for (final s in scopes) s.catalogItemId: s};

    return items.map((item) {
      final scope = scopeByItemId[item.id];
      if (scope != null) {
        return item.copyWith(
          basePrice: scope.priceOverride ?? item.basePrice,
          minQuantity: scope.minQuantityOverride ?? item.minQuantity,
          metadata: scope.metadataOverride ?? item.metadata,
        );
      }
      return item;
    }).toList();
  }

  /// Obtiene una partida de catálogo por su ID.
  Future<CrmCatalogItem?> getCatalogItemById(int id) async {
    return await CrmCatalogItem.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Valida la sintaxis y el esquema del JSON de metadata según calculationType.
  void _validateMetadata(String calculationType, String? metadata) {
    if (metadata == null || metadata.trim().isEmpty) {
      if (calculationType == 'PER_POSITION') {
        throw const FormatException(
          'La partida de tipo Puesto (PER_POSITION) requiere metadata JSON con "hoursPerShift" y "daysPerMonth".',
        );
      }
      return;
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(metadata) as Map<String, dynamic>;
    } catch (e) {
      throw FormatException(
        'El campo metadata debe contener un JSON válido: $e',
      );
    }

    if (calculationType == 'PER_POSITION') {
      final hours = decoded['hoursPerShift'];
      final days = decoded['daysPerMonth'];
      if (hours == null || (hours is num && hours <= 0)) {
        throw const FormatException(
          'Metadata inválido para PER_POSITION: "hoursPerShift" debe ser un número mayor a 0.',
        );
      }
      if (days == null || (days is num && days <= 0)) {
        throw const FormatException(
          'Metadata inválido para PER_POSITION: "daysPerMonth" debe ser un número mayor a 0.',
        );
      }
    }
  }

  /// Crea una nueva partida en el catálogo con validación de unicidad y metadata.
  Future<CrmCatalogItem> createCatalogItem(CrmCatalogItem item) async {
    final cleanCode = item.code.trim().toUpperCase();
    final cleanConcept = item.concept.trim();

    // 1. Unicidad de código
    final existingCode = await CrmCatalogItem.db.findFirstRow(
      session,
      where: (t) => t.code.equals(cleanCode),
    );
    if (existingCode != null) {
      throw FormatException(
        'El código de partida "$cleanCode" ya está registrado en el catálogo.',
      );
    }

    // 2. Unicidad de concepto dentro de la misma línea de servicio
    final existingConcept = await CrmCatalogItem.db.findFirstRow(
      session,
      where: (t) =>
          t.serviceLineId.equals(item.serviceLineId) &
          t.concept.ilike(cleanConcept) &
          t.isDeleted.equals(false),
    );
    if (existingConcept != null) {
      throw FormatException(
        'Ya existe una partida con el concepto "$cleanConcept" en la misma línea de servicio.',
      );
    }

    // 3. Validar JSON de metadata
    _validateMetadata(item.calculationType, item.metadata);

    final now = DateTime.now().toUtc();
    final toInsert = item.copyWith(
      code: cleanCode,
      concept: cleanConcept,
      version: 1,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmCatalogItem.db.insertRow(session, toInsert);
  }

  /// Actualiza una partida con versionado automático si cambia el cálculo o precio.
  Future<CrmCatalogItem> updateCatalogItem(CrmCatalogItem item) async {
    final existing = await getCatalogItemById(item.id!);
    if (existing == null) {
      throw FormatException('La partida solicitada no existe.');
    }

    // Validar metadata
    _validateMetadata(item.calculationType, item.metadata);

    // Versionado sensible a cualquier parámetro que altere el cálculo
    final priceChanged = existing.basePrice != item.basePrice;
    final calcChanged = existing.calculationType != item.calculationType;
    final unitChanged = existing.unitType != item.unitType;
    final metaChanged = existing.metadata != item.metadata;

    final newVersion = (priceChanged || calcChanged || unitChanged || metaChanged)
        ? existing.version + 1
        : existing.version;

    final now = DateTime.now().toUtc();
    final toUpdate = item.copyWith(
      version: newVersion,
      updatedAt: now,
    );

    return await CrmCatalogItem.db.updateRow(session, toUpdate);
  }

  /// Eliminación segura con regla de preservación de histórico.
  Future<bool> deleteCatalogItem(int id) async {
    final existing = await getCatalogItemById(id);
    if (existing == null) return false;

    final now = DateTime.now().toUtc();

    // Siempre aplicamos soft-delete para no romper integridad histórica ni cotizaciones previas
    await CrmCatalogItem.db.updateRow(
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
  // 4. TARIFAS DIFERENCIADAS POR RUBRO (SCOPES)
  // ===========================================================================

  /// Lista los scopes de precios especiales para una partida.
  Future<List<CrmCatalogItemScope>> listScopesForItem(int catalogItemId) async {
    return await CrmCatalogItemScope.db.find(
      session,
      where: (t) =>
          t.catalogItemId.equals(catalogItemId) & t.isDeleted.equals(false),
    );
  }

  /// Guarda o actualiza una tarifa diferenciada para un sector (Upsert atómico).
  Future<CrmCatalogItemScope> setCatalogItemScope(
    CrmCatalogItemScope scope,
  ) async {
    final existing = await CrmCatalogItemScope.db.findFirstRow(
      session,
      where: (t) =>
          t.catalogItemId.equals(scope.catalogItemId) &
          t.sectorId.equals(scope.sectorId),
    );

    final now = DateTime.now().toUtc();
    if (existing != null) {
      final updated = existing.copyWith(
        priceOverride: scope.priceOverride,
        minQuantityOverride: scope.minQuantityOverride,
        metadataOverride: scope.metadataOverride,
        isActive: scope.isActive,
        isDeleted: false,
        updatedAt: now,
      );
      return await CrmCatalogItemScope.db.updateRow(session, updated);
    } else {
      final inserted = scope.copyWith(
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      return await CrmCatalogItemScope.db.insertRow(session, inserted);
    }
  }
}
