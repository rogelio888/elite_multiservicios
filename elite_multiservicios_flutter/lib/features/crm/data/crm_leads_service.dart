import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import '../../../main.dart' show client;

/// Modelo de vista para la prospección comercial (Outbound / Maps / Directorios).
/// Vinculado directamente a la entidad CrmLead de PostgreSQL vía Serverpod.
class LeadModel {
  final String id;
  final int? rawId;
  final String? code;
  final String date; // Fecha de prospección
  final String advisor; // Asesor comercial responsable
  final String company; // Nombre comercial de la empresa o edificio
  final String? companyUrl; // Enlace web o Google Maps asociado
  final String sector; // Rubro / Industria (Clínicas, Colegios, Banca, etc.)
  final String origin; // Canal de captación (Google Maps, Web, Teléfono, etc.)
  final String? requestedService; // Servicio solicitado / Línea de interés
  final String address; // Dirección física / Ubicación
  final String phone; // Teléfono(s) o WhatsApp
  final String? emailOrWeb; // Correo o enlace oficial
  final String
  status; // 'Prospectado', 'Contactado', 'En Espera de Respuesta', 'Interesado (Calificado)', 'Descartado'
  final String temperature; // 'Frío', 'Templado', 'Caliente'
  final String contactPerson; // Nombre del contacto o decisor
  final String? notes; // Historial y notas comerciales
  final double estimatedValue; // Valor mensual o de obra estimado
  final bool isPromoted; // Si ya fue promovido al Pipeline comercial
  final int? promotedOpportunityId;

  const LeadModel({
    required this.id,
    this.rawId,
    this.code,
    required this.date,
    required this.advisor,
    required this.company,
    this.companyUrl,
    required this.sector,
    this.origin = 'Google Maps',
    this.requestedService,
    required this.address,
    required this.phone,
    this.emailOrWeb,
    required this.status,
    this.temperature = 'Templado',
    this.contactPerson = 'Encargado de Compras / Administración',
    this.notes,
    this.estimatedValue = 0.0,
    this.isPromoted = false,
    this.promotedOpportunityId,
  });

  /// Mapea la entidad real de Serverpod / PostgreSQL al modelo de vista Flutter.
  factory LeadModel.fromCrmLead(CrmLead lead) {
    final d = lead.createdAt.toLocal();
    final formattedDate =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return LeadModel(
      id: lead.code.isNotEmpty ? lead.code : (lead.id?.toString() ?? ''),
      rawId: lead.id,
      code: lead.code,
      date: formattedDate,
      advisor: lead.advisor,
      company: lead.company,
      companyUrl: lead.companyUrl,
      sector: lead.sector,
      origin: lead.origin,
      requestedService: lead.requestedService,
      address: lead.address,
      phone: lead.phone,
      emailOrWeb: lead.emailOrWeb,
      status: lead.status,
      temperature: lead.temperature,
      contactPerson: lead.contactPerson,
      notes: lead.notes,
      estimatedValue: lead.estimatedValue,
      isPromoted: lead.isPromoted,
      promotedOpportunityId: lead.promotedOpportunityId,
    );
  }

  /// Convierte el modelo de vista en la entidad Serializable de Serverpod para persistir.
  CrmLead toCrmLead() {
    return CrmLead(
      id: rawId,
      code: code ?? (id.startsWith('PROSP') ? id : ''),
      company: company,
      companyUrl: companyUrl,
      sector: sector,
      origin: origin,
      requestedService: requestedService,
      advisor: advisor,
      address: address,
      phone: phone,
      emailOrWeb: emailOrWeb,
      status: status,
      temperature: temperature,
      contactPerson: contactPerson,
      notes: notes,
      estimatedValue: estimatedValue,
      isPromoted: isPromoted,
      promotedOpportunityId: promotedOpportunityId,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  LeadModel copyWith({
    String? id,
    int? rawId,
    String? code,
    String? date,
    String? advisor,
    String? company,
    String? companyUrl,
    String? sector,
    String? origin,
    String? requestedService,
    String? address,
    String? phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    String? contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
    int? promotedOpportunityId,
  }) {
    return LeadModel(
      id: id ?? this.id,
      rawId: rawId ?? this.rawId,
      code: code ?? this.code,
      date: date ?? this.date,
      advisor: advisor ?? this.advisor,
      company: company ?? this.company,
      companyUrl: companyUrl ?? this.companyUrl,
      sector: sector ?? this.sector,
      origin: origin ?? this.origin,
      requestedService: requestedService ?? this.requestedService,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      emailOrWeb: emailOrWeb ?? this.emailOrWeb,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      contactPerson: contactPerson ?? this.contactPerson,
      notes: notes ?? this.notes,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      isPromoted: isPromoted ?? this.isPromoted,
      promotedOpportunityId:
          promotedOpportunityId ?? this.promotedOpportunityId,
    );
  }
}

/// Servicio Singleton reactivo de Prospectos del CRM conectado al Backend Serverpod.
/// Cumple con la directiva 'no-mock-policy': Cero datos hardcodeados en el frontend.
class CrmLeadsService {
  static final CrmLeadsService _instance = CrmLeadsService._internal();
  factory CrmLeadsService({Client? customClient}) {
    if (customClient != null) {
      _instance._clientOverride = customClient;
    }
    return _instance;
  }

  CrmLeadsService._internal();

  Client? _clientOverride;
  Client get _activeClient => _clientOverride ?? client;

  final ValueNotifier<List<LeadModel>> leadsNotifier =
      ValueNotifier<List<LeadModel>>([]);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  CrmLeadMetricsResponse? _metrics;
  CrmLeadMetricsResponse? get metrics => _metrics;

  List<LeadModel> get leads => leadsNotifier.value;
  bool get isLoading => isLoadingNotifier.value;
  String? get error => errorNotifier.value;

  /// Carga la lista de prospectos reales desde PostgreSQL mediante RPC.
  Future<void> loadLeads({
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
  }) async {
    isLoadingNotifier.value = true;
    errorNotifier.value = null;

    try {
      final remoteLeads = await _activeClient.crmLeads.listLeads(
        limit: 200,
        offset: 0,
        search: search,
        sector: sector,
        status: status,
        temperature: temperature,
        advisor: advisor,
      );

      leadsNotifier.value = remoteLeads.map(LeadModel.fromCrmLead).toList();

      try {
        _metrics = await _activeClient.crmLeads.getMetrics();
      } catch (e) {
        debugPrint('[CrmLeadsService] Error al consultar métricas: $e');
      }
    } catch (e) {
      debugPrint('[CrmLeadsService] Error al cargar prospectos reales: $e');
      errorNotifier.value = e.toString();
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  /// Registra un nuevo prospecto en PostgreSQL.
  Future<LeadModel?> addLead(LeadModel lead) async {
    try {
      final created = await _activeClient.crmLeads.createLead(lead.toCrmLead());
      final createdModel = LeadModel.fromCrmLead(created);
      leadsNotifier.value = [createdModel, ...leadsNotifier.value];
      await loadLeads();
      return createdModel;
    } catch (e) {
      debugPrint('[CrmLeadsService] Error al crear prospecto: $e');
      errorNotifier.value = e.toString();
      rethrow;
    }
  }

  /// Actualiza los datos generales de un prospecto en PostgreSQL.
  Future<void> updateLead(LeadModel updated) async {
    try {
      await _activeClient.crmLeads.updateLead(updated.toCrmLead());
      leadsNotifier.value = [
        for (final l in leadsNotifier.value)
          if (l.id == updated.id ||
              (l.rawId != null && l.rawId == updated.rawId))
            updated
          else
            l,
      ];
      await loadLeads();
    } catch (e) {
      debugPrint('[CrmLeadsService] Error al actualizar prospecto: $e');
      errorNotifier.value = e.toString();
      rethrow;
    }
  }

  /// Actualiza el estado comercial en PostgreSQL.
  Future<void> updateStatus(String leadId, String newStatus) async {
    final lead = leadsNotifier.value.firstWhere(
      (l) => l.id == leadId,
      orElse: () => LeadModel(
        id: leadId,
        date: '',
        advisor: '',
        company: '',
        sector: '',
        address: '',
        phone: '',
        status: '',
      ),
    );
    final rawId = lead.rawId ?? int.tryParse(leadId);

    // Si el prospecto ya fue promovido al Pipeline Comercial, no se puede degradar su estado
    if (lead.isPromoted) {
      debugPrint(
        '[CrmLeadsService] Prospecto $leadId ya promovido al Pipeline; estado protegido contra degradación.',
      );
      return;
    }

    // Actualización optimista local
    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId) l.copyWith(status: newStatus) else l,
    ];

    if (rawId != null) {
      try {
        await _activeClient.crmLeads.updateStatus(rawId, newStatus);
      } catch (e) {
        debugPrint('[CrmLeadsService] Error al persistir nuevo estado: $e');
        await loadLeads();
      }
    }
  }

  /// Actualiza la temperatura comercial en PostgreSQL.
  Future<void> updateTemperature(String leadId, String newTemp) async {
    final lead = leadsNotifier.value.firstWhere(
      (l) => l.id == leadId,
      orElse: () => LeadModel(
        id: leadId,
        date: '',
        advisor: '',
        company: '',
        sector: '',
        address: '',
        phone: '',
        status: '',
      ),
    );
    final rawId = lead.rawId ?? int.tryParse(leadId);

    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId) l.copyWith(temperature: newTemp) else l,
    ];

    if (rawId != null) {
      try {
        await _activeClient.crmLeads.updateTemperature(rawId, newTemp);
      } catch (e) {
        debugPrint('[CrmLeadsService] Error al persistir temperatura: $e');
        await loadLeads();
      }
    }
  }

  /// Actualiza las notas comerciales en PostgreSQL.
  Future<void> updateNotes(String leadId, String newNotes) async {
    final lead = leadsNotifier.value.firstWhere(
      (l) => l.id == leadId,
      orElse: () => LeadModel(
        id: leadId,
        date: '',
        advisor: '',
        company: '',
        sector: '',
        address: '',
        phone: '',
        status: '',
      ),
    );
    final updated = lead.copyWith(notes: newNotes);
    await updateLead(updated);
  }

  /// Promueve el prospecto a Oportunidad en el Pipeline en PostgreSQL.
  Future<void> markPromoted(String leadId, {String? opportunityId}) async {
    final lead = leadsNotifier.value.firstWhere(
      (l) => l.id == leadId,
      orElse: () => LeadModel(
        id: leadId,
        date: '',
        advisor: '',
        company: '',
        sector: '',
        address: '',
        phone: '',
        status: '',
      ),
    );
    final rawId = lead.rawId ?? int.tryParse(leadId);
    final rawOppId = opportunityId != null
        ? int.tryParse(opportunityId.replaceAll(RegExp(r'[^0-9]'), ''))
        : null;

    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId)
          l.copyWith(
            isPromoted: true,
            status: 'Interesado (Calificado)',
            temperature: 'Caliente',
          )
        else
          l,
    ];

    if (rawId != null) {
      try {
        await _activeClient.crmLeads.markPromoted(rawId, rawOppId);
      } catch (e) {
        debugPrint('[CrmLeadsService] Error al promover prospecto: $e');
        await loadLeads();
      }
    }
  }

  /// Elimina (Soft Delete) el prospecto en PostgreSQL.
  Future<void> deleteLead(String leadId) async {
    final lead = leadsNotifier.value.firstWhere(
      (l) => l.id == leadId,
      orElse: () => LeadModel(
        id: leadId,
        date: '',
        advisor: '',
        company: '',
        sector: '',
        address: '',
        phone: '',
        status: '',
      ),
    );
    final rawId = lead.rawId ?? int.tryParse(leadId);

    leadsNotifier.value = leadsNotifier.value
        .where((l) => l.id != leadId)
        .toList();

    if (rawId != null) {
      try {
        await _activeClient.crmLeads.deleteLead(rawId);
      } catch (e) {
        debugPrint('[CrmLeadsService] Error al eliminar prospecto: $e');
        await loadLeads();
      }
    }
  }

  /// Método para inicializar prospectos en pruebas unitarias aisladas sin red.
  @visibleForTesting
  void setInitialLeadsForTesting(List<LeadModel> testLeads) {
    leadsNotifier.value = List.from(testLeads);
  }

  // --- Métricas Comerciales Calculadas en Tiempo Real ---

  int get totalCount => leads.length;

  int get contactedCount => leads.where((l) => l.status == 'Contactado').length;

  int get waitingCount =>
      leads.where((l) => l.status == 'En Espera de Respuesta').length;

  int get qualifiedCount =>
      leads.where((l) => l.status == 'Interesado (Calificado)').length;

  int get hotCount => leads.where((l) => l.temperature == 'Caliente').length;

  double get conversionRate =>
      totalCount > 0 ? (qualifiedCount / totalCount) * 100 : 0.0;

  double get totalPipelinePotential => leads
      .where((l) => l.status != 'Descartado')
      .fold<double>(0.0, (acc, l) => acc + l.estimatedValue);
}
