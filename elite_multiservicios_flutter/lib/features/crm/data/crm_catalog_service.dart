import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import '../../../main.dart' show client;

/// Servicio singleton reactivo para la administración del Catálogo de Servicios,
/// Rubros Industriales, Líneas de Servicio y Tarifas Diferenciadas por Rubro (Scopes).
class CrmCatalogService extends ChangeNotifier {
  static final CrmCatalogService _instance = CrmCatalogService._internal();
  factory CrmCatalogService({Client? customClient}) {
    if (customClient != null) {
      _instance._clientOverride = customClient;
    }
    return _instance;
  }

  static CrmCatalogService get instance => _instance;

  CrmCatalogService._internal();

  Client? _clientOverride;
  Client get _activeClient => _clientOverride ?? client;

  List<CrmSector> _sectors = [];
  List<CrmServiceLine> _serviceLines = [];
  List<CrmCatalogItem> _catalogItems = [];
  final Map<int, List<CrmCatalogItemScope>> _scopesByItem = {};

  bool _isLoading = false;
  String? _error;

  List<CrmSector> get sectors => List.unmodifiable(_sectors);
  List<CrmServiceLine> get serviceLines => List.unmodifiable(_serviceLines);
  List<CrmCatalogItem> get catalogItems => List.unmodifiable(_catalogItems);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga inicial completa de sectores, líneas y partidas maestras.
  Future<void> loadAll({
    int? sectorId,
    int? serviceLineId,
    String? category,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _activeClient.crmCatalog.listSectors(includeInactive: true),
        _activeClient.crmCatalog.listServiceLines(includeInactive: true),
        _activeClient.crmCatalog.listCatalogItems(
          sectorId: sectorId,
          serviceLineId: serviceLineId,
          category: category,
          activeOnly: false,
        ),
      ]);

      _sectors = (results[0] as List).cast<CrmSector>();
      _serviceLines = (results[1] as List).cast<CrmServiceLine>();
      _catalogItems = (results[2] as List).cast<CrmCatalogItem>();
    } catch (e) {
      _error = 'Error cargando catálogo: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // 1. SECTORES / RUBROS
  // ===========================================================================

  Future<List<CrmSector>> loadSectors({bool includeInactive = false}) async {
    try {
      final list = await _activeClient.crmCatalog.listSectors(
        includeInactive: includeInactive,
      );
      _sectors = list;
      notifyListeners();
      return list;
    } catch (e) {
      _error = 'Error cargando sectores: $e';
      notifyListeners();
      return _sectors;
    }
  }

  Future<CrmSector> createSector(CrmSector sector) async {
    try {
      final created = await _activeClient.crmCatalog.createSector(sector);
      _sectors.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = 'Error creando sector: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<CrmSector> updateSector(CrmSector sector) async {
    try {
      final updated = await _activeClient.crmCatalog.updateSector(sector);
      final idx = _sectors.indexWhere((s) => s.id == updated.id);
      if (idx != -1) {
        _sectors[idx] = updated;
      }
      notifyListeners();
      return updated;
    } catch (e) {
      _error = 'Error actualizando sector: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> deleteSector(int id) async {
    try {
      final ok = await _activeClient.crmCatalog.deleteSector(id);
      if (ok) {
        _sectors.removeWhere((s) => s.id == id);
        notifyListeners();
      }
      return ok;
    } catch (e) {
      _error = 'Error eliminando sector: $e';
      notifyListeners();
      rethrow;
    }
  }

  // ===========================================================================
  // 2. LÍNEAS DE SERVICIO
  // ===========================================================================

  Future<List<CrmServiceLine>> loadServiceLines({
    String? category,
    bool includeInactive = false,
  }) async {
    try {
      final list = await _activeClient.crmCatalog.listServiceLines(
        category: category,
        includeInactive: includeInactive,
      );
      _serviceLines = list;
      notifyListeners();
      return list;
    } catch (e) {
      _error = 'Error cargando líneas: $e';
      notifyListeners();
      return _serviceLines;
    }
  }

  Future<CrmServiceLine> createServiceLine(CrmServiceLine line) async {
    try {
      final created = await _activeClient.crmCatalog.createServiceLine(line);
      _serviceLines.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = 'Error creando línea de servicio: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<CrmServiceLine> updateServiceLine(CrmServiceLine line) async {
    try {
      final updated = await _activeClient.crmCatalog.updateServiceLine(line);
      final idx = _serviceLines.indexWhere((l) => l.id == updated.id);
      if (idx != -1) {
        _serviceLines[idx] = updated;
      }
      notifyListeners();
      return updated;
    } catch (e) {
      _error = 'Error actualizando línea de servicio: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> deleteServiceLine(int id) async {
    try {
      final ok = await _activeClient.crmCatalog.deleteServiceLine(id);
      if (ok) {
        _serviceLines.removeWhere((l) => l.id == id);
        notifyListeners();
      }
      return ok;
    } catch (e) {
      _error = 'Error eliminando línea de servicio: $e';
      notifyListeners();
      rethrow;
    }
  }

  // ===========================================================================
  // 3. CATÁLOGO DE PARTIDAS
  // ===========================================================================

  Future<List<CrmCatalogItem>> loadCatalogItems({
    int? sectorId,
    int? serviceLineId,
    String? category,
    bool activeOnly = false,
  }) async {
    try {
      final list = await _activeClient.crmCatalog.listCatalogItems(
        sectorId: sectorId,
        serviceLineId: serviceLineId,
        category: category,
        activeOnly: activeOnly,
      );
      _catalogItems = list;
      notifyListeners();
      return list;
    } catch (e) {
      _error = 'Error cargando partidas: $e';
      notifyListeners();
      return _catalogItems;
    }
  }

  Future<CrmCatalogItem> createCatalogItem(CrmCatalogItem item) async {
    try {
      final created = await _activeClient.crmCatalog.createCatalogItem(item);
      _catalogItems.add(created);
      notifyListeners();
      return created;
    } catch (e) {
      _error = 'Error creando partida: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<CrmCatalogItem> updateCatalogItem(CrmCatalogItem item) async {
    try {
      final updated = await _activeClient.crmCatalog.updateCatalogItem(item);
      final idx = _catalogItems.indexWhere((i) => i.id == updated.id);
      if (idx != -1) {
        _catalogItems[idx] = updated;
      }
      notifyListeners();
      return updated;
    } catch (e) {
      _error = 'Error actualizando partida: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> deleteCatalogItem(int id) async {
    try {
      final ok = await _activeClient.crmCatalog.deleteCatalogItem(id);
      if (ok) {
        _catalogItems.removeWhere((i) => i.id == id);
        notifyListeners();
      }
      return ok;
    } catch (e) {
      _error = 'Error eliminando partida: $e';
      notifyListeners();
      rethrow;
    }
  }

  // ===========================================================================
  // 4. TARIFAS DIFERENCIADAS (SCOPES)
  // ===========================================================================

  List<CrmCatalogItemScope> getCachedScopes(int catalogItemId) {
    return _scopesByItem[catalogItemId] ?? [];
  }

  Future<List<CrmCatalogItemScope>> loadScopesForItem(int catalogItemId) async {
    try {
      final list = await _activeClient.crmCatalog.listScopesForItem(catalogItemId);
      _scopesByItem[catalogItemId] = list;
      notifyListeners();
      return list;
    } catch (e) {
      _error = 'Error cargando tarifas especiales: $e';
      notifyListeners();
      return _scopesByItem[catalogItemId] ?? [];
    }
  }

  Future<CrmCatalogItemScope> setCatalogItemScope(
    CrmCatalogItemScope scope,
  ) async {
    try {
      final saved = await _activeClient.crmCatalog.setCatalogItemScope(scope);
      final list = _scopesByItem.putIfAbsent(scope.catalogItemId, () => []);
      final idx = list.indexWhere((s) => s.sectorId == scope.sectorId);
      if (idx != -1) {
        list[idx] = saved;
      } else {
        list.add(saved);
      }
      notifyListeners();
      return saved;
    } catch (e) {
      _error = 'Error guardando tarifa diferenciada: $e';
      notifyListeners();
      rethrow;
    }
  }
}
