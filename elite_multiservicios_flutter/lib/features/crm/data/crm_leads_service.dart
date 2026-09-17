import 'package:flutter/foundation.dart';

/// Modelo enterprise para la prospección comercial (Outbound / Maps / Directorios).
class LeadModel {
  final String id;
  final String date; // Fecha de prospección
  final String advisor; // Asesor responsable
  final String company; // Nombre comercial de la empresa o edificio
  final String? companyUrl; // Enlace web o Maps asociado
  final String sector; // Rubro / Industria (Clínicas, Colegios, Banca, etc.)
  final String address; // Dirección física / Ubicación
  final String phone; // Teléfono(s) o WhatsApp
  final String? emailOrWeb; // Correo o enlace oficial
  final String status; // 'Prospectado', 'Contactado', 'En Espera de Respuesta', 'Interesado (Calificado)', 'Descartado'
  final String temperature; // 'Frío', 'Templado', 'Caliente'
  final String contactPerson; // Nombre del contacto o decisor
  final String? notes; // Historial y notas comerciales
  final double estimatedValue; // Valor mensual o de obra estimado (opcional)
  final bool isPromoted; // Si ya fue promovido al Pipeline comercial

  const LeadModel({
    required this.id,
    required this.date,
    required this.advisor,
    required this.company,
    this.companyUrl,
    required this.sector,
    required this.address,
    required this.phone,
    this.emailOrWeb,
    required this.status,
    this.temperature = 'Templado',
    this.contactPerson = 'Encargado de Compras / Administración',
    this.notes,
    this.estimatedValue = 0.0,
    this.isPromoted = false,
  });

  LeadModel copyWith({
    String? date,
    String? advisor,
    String? company,
    String? companyUrl,
    String? sector,
    String? address,
    String? phone,
    String? emailOrWeb,
    String? status,
    String? temperature,
    String? contactPerson,
    String? notes,
    double? estimatedValue,
    bool? isPromoted,
  }) {
    return LeadModel(
      id: id,
      date: date ?? this.date,
      advisor: advisor ?? this.advisor,
      company: company ?? this.company,
      companyUrl: companyUrl ?? this.companyUrl,
      sector: sector ?? this.sector,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      emailOrWeb: emailOrWeb ?? this.emailOrWeb,
      status: status ?? this.status,
      temperature: temperature ?? this.temperature,
      contactPerson: contactPerson ?? this.contactPerson,
      notes: notes ?? this.notes,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      isPromoted: isPromoted ?? this.isPromoted,
    );
  }
}

/// Servicio Singleton reactivo de Prospectos del CRM.
class CrmLeadsService {
  static final CrmLeadsService _instance = CrmLeadsService._internal();
  factory CrmLeadsService() => _instance;

  final ValueNotifier<List<LeadModel>> leadsNotifier = ValueNotifier<List<LeadModel>>([]);

  CrmLeadsService._internal() {
    _initializeSeeds();
  }

  List<LeadModel> get leads => leadsNotifier.value;

  void _initializeSeeds() {
    leadsNotifier.value = [
      const LeadModel(
        id: 'PROSP-001',
        date: '18/08/2026',
        advisor: 'Rodrigo Acha',
        company: 'EMBRIOVID',
        companyUrl: 'https://www.embriovid.com/contactos',
        sector: 'Clínicas y centros médicos',
        address: 'Edif. Tacuaral, Av. San Martín #200, Equipetrol',
        phone: '77042047',
        emailOrWeb: 'https://www.embriovid.com/contactos',
        status: 'En Espera de Respuesta',
        temperature: 'Templado',
        contactPerson: 'Lic. Maria Eugenia (Recepción)',
        notes: 'Llamada inicial realizada. Recepción consultará con administración el martes para fijar reunión.',
        estimatedValue: 6800.0,
      ),
      const LeadModel(
        id: 'PROSP-002',
        date: '19/08/2026',
        advisor: 'Vanessa Requejo',
        company: 'INSTITUTO DE SALUD REPRODUCTIVA',
        companyUrl: 'https://www.facebook.com/institutosalud',
        sector: 'Clínicas y centros médicos',
        address: 'Barrio Equipetrol Norte Calle "F" Este Esq. Aviador Pinto',
        phone: '77042047',
        emailOrWeb: 'contacto@isr-bolivia.com',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Dr. Alejandro Peña',
        notes: 'Se envió portafolio institucional de limpieza técnica y desinfección hospitalaria con protocolos biocidas.',
        estimatedValue: 7400.0,
      ),
      const LeadModel(
        id: 'PROSP-003',
        date: '19/08/2026',
        advisor: 'Vanessa Requejo',
        company: 'GINOFIV',
        companyUrl: 'https://ginofiv.com.bo/',
        sector: 'Clínicas y centros médicos',
        address: 'Av. Alemana calle Sao No 2450 (entre 2do y 3er anillo)',
        phone: '79683941',
        emailOrWeb: 'https://ginofiv.com.bo/',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        contactPerson: 'Ing. Sandra Hurtado (Gerente Operaciones)',
        notes: 'Solicitaron cotización formal para 2 operarios de limpieza hospitalaria turno matutino y seguridad perimetral.',
        estimatedValue: 9200.0,
      ),
      const LeadModel(
        id: 'PROSP-004',
        date: '19/08/2026',
        advisor: 'Rodrigo Acha',
        company: 'Clínica Roberto Bacarreza',
        companyUrl: 'https://clinicarobertobacarreza.com/',
        sector: 'Clínicas y centros médicos',
        address: 'Calle República Dominicana 2068, entre calles Nicaragua y Villalobos',
        phone: '76787767',
        emailOrWeb: 'https://clinicarobertobacarreza.com/',
        status: 'Prospectado',
        temperature: 'Frío',
        contactPerson: 'Administración General',
        notes: 'Ficha capturada de Google Maps. Pendiente primera llamada de prospección en frío.',
        estimatedValue: 5500.0,
      ),
      const LeadModel(
        id: 'PROSP-005',
        date: '19/08/2026',
        advisor: 'Vanessa Requejo',
        company: 'Clínica Santa Lucía',
        companyUrl: 'https://www.clinicasantalucia.com',
        sector: 'Clínicas y centros médicos',
        address: 'Av. Salvador esq. Calle J, Zona Norte',
        phone: '3453939',
        emailOrWeb: 'contacto@clinicasantalucia.com',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Dra. Paola Suarez',
        notes: 'Interesados puntualmente en limpieza profunda de vidrios exteriores en altura y pulido de pisos.',
        estimatedValue: 4800.0,
      ),
      const LeadModel(
        id: 'PROSP-006',
        date: '19/08/2026',
        advisor: 'Vanessa Requejo',
        company: 'Universal Tours',
        companyUrl: 'https://universaltours.com.bo/',
        sector: 'Corporativo / Oficinas',
        address: 'Calle Dr. Alberto Seleme Antelo No. 35 (Calle-H), Equipetrol Norte',
        phone: '77360004',
        emailOrWeb: 'https://universaltours.com.bo/',
        status: 'En Espera de Respuesta',
        temperature: 'Templado',
        contactPerson: 'Lic. Fernando Prado',
        notes: 'Mensaje de WhatsApp enviado directamente al gerente comercial con catálogo de mantenimiento corporativo.',
        estimatedValue: 3900.0,
      ),
      const LeadModel(
        id: 'PROSP-007',
        date: '19/08/2026',
        advisor: 'Rodrigo Acha',
        company: 'MT Smartravel',
        companyUrl: 'https://www.facebook.com/MTsmartravel',
        sector: 'Corporativo / Oficinas',
        address: 'Edificio YOU Smart Studio, Local 116, Equipetrol Norte',
        phone: '72191071',
        emailOrWeb: 'info@mtsmartravel.bo',
        status: 'Prospectado',
        temperature: 'Frío',
        contactPerson: 'Recepción Central',
        notes: 'Oficina comercial dentro de complejo de departamentos y corporativos.',
        estimatedValue: 2800.0,
      ),
      const LeadModel(
        id: 'PROSP-008',
        date: '19/08/2026',
        advisor: 'Rodrigo Acha',
        company: 'CloudIt Bolivia',
        companyUrl: 'https://cloud-it.lat/servicios/',
        sector: 'Corporativo / Oficinas',
        address: 'Calle Pablo Sanz N. 11, Edificio ITAJU, Planta Baja / Sirari',
        phone: '69701255',
        emailOrWeb: 'contacto@cloud-it.lat',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Ing. Rodrigo Justiniano',
        notes: 'Empresa tecnológica con servidores en sitio. Se coordinará visita para evaluar control de acceso y limpieza técnica.',
        estimatedValue: 6200.0,
      ),
      const LeadModel(
        id: 'PROSP-009',
        date: '19/08/2026',
        advisor: 'Rodrigo Acha',
        company: 'TLG Landmark Group',
        companyUrl: 'https://tlg.bo/contacto/',
        sector: 'Corporativo / Oficinas',
        address: 'Edificio You Plaza, PB Of. 01, Equipetrol Norte',
        phone: '77351000',
        emailOrWeb: 'https://tlg.bo/contacto/',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        contactPerson: 'Arq. Mario Valverde (Facility Manager)',
        notes: 'Visita técnica urgente solicitada para mantenimiento preventivo integral y personal de mantenimiento fijo.',
        estimatedValue: 14500.0,
      ),
      const LeadModel(
        id: 'PROSP-010',
        date: '25/08/2026',
        advisor: 'Vanessa Requejo',
        company: 'TELIS S.R.L.',
        companyUrl: null,
        sector: 'Corporativo / Oficinas',
        address: 'C. F Nº 144, Barrio Equipetrol',
        phone: '33441541',
        emailOrWeb: 'info@telis.com.bo',
        status: 'Prospectado',
        temperature: 'Frío',
        contactPerson: 'Administración',
        notes: 'Edificio corporativo con necesidad aparente de jardinería y mantenimiento de fachada.',
        estimatedValue: 3500.0,
      ),
      const LeadModel(
        id: 'PROSP-011',
        date: '26/08/2026',
        advisor: 'Sara',
        company: 'Colegio Saint Peter Campus Norte',
        companyUrl: 'https://saintpeter.edu.bo',
        sector: 'Colegios & Educación',
        address: 'Km 8 Carretera al Norte, Santa Cruz',
        phone: '78901234',
        emailOrWeb: 'mantenimiento@saintpeter.edu.bo',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        contactPerson: 'Prof. Roberto Cuellar (Administrador)',
        notes: 'Requieren corte de césped mecanizado quincenal, limpieza de canchas deportivas y portería.',
        estimatedValue: 8900.0,
      ),
      const LeadModel(
        id: 'PROSP-012',
        date: '27/08/2026',
        advisor: 'Juan',
        company: 'Instituto Técnico Domingo Savio',
        companyUrl: 'https://domingosavio.edu.bo',
        sector: 'Colegios & Educación',
        address: 'Av. Cristo Redentor entre 3er y 4to anillo',
        phone: '3429988',
        emailOrWeb: 'administracion@domingosavio.edu.bo',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Lic. Claudia Montero',
        notes: 'Reunión acordada con el comité de compras para presentar propuesta de limpieza y suministros de papel.',
        estimatedValue: 5800.0,
      ),
    ];
  }

  // --- Operaciones CRUD & Mutaciones ---

  void addLead(LeadModel lead) {
    leadsNotifier.value = [lead, ...leadsNotifier.value];
  }

  void updateLead(LeadModel updated) {
    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == updated.id) updated else l,
    ];
  }

  void updateStatus(String leadId, String newStatus) {
    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId) l.copyWith(status: newStatus) else l,
    ];
  }

  void updateTemperature(String leadId, String newTemp) {
    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId) l.copyWith(temperature: newTemp) else l,
    ];
  }

  void updateNotes(String leadId, String newNotes) {
    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId) l.copyWith(notes: newNotes) else l,
    ];
  }

  void markPromoted(String leadId) {
    leadsNotifier.value = [
      for (final l in leadsNotifier.value)
        if (l.id == leadId) l.copyWith(isPromoted: true, status: 'Interesado (Calificado)', temperature: 'Caliente') else l,
    ];
  }

  void deleteLead(String leadId) {
    leadsNotifier.value = leadsNotifier.value.where((l) => l.id != leadId).toList();
  }

  // --- Métricas Comerciales Calculadas en Tiempo Real ---

  int get totalCount => leads.length;

  int get contactedCount => leads.where((l) => l.status == 'Contactado').length;

  int get waitingCount => leads.where((l) => l.status == 'En Espera de Respuesta').length;

  int get qualifiedCount => leads.where((l) => l.status == 'Interesado (Calificado)').length;

  int get hotCount => leads.where((l) => l.temperature == 'Caliente').length;

  double get conversionRate => totalCount > 0 ? (qualifiedCount / totalCount) * 100 : 0.0;

  double get totalPipelinePotential => leads
      .where((l) => l.status != 'Descartado')
      .fold<double>(0.0, (acc, l) => acc + l.estimatedValue);
}
