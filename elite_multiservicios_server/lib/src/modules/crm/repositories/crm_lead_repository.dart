import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Servicio de datos y persistencia para la gestión de prospectos comerciales (CRM Leads) en PostgreSQL.
class CrmLeadDataService {
  final Session session;

  const CrmLeadDataService(this.session);

  /// Lista prospectos con filtros avanzados, búsqueda y paginación.
  Future<List<CrmLead>> listLeads({
    int limit = 100,
    int offset = 0,
    String? search,
    String? sector,
    String? status,
    String? temperature,
    String? advisor,
  }) async {
    return await CrmLead.db.find(
      session,
      where: (t) {
        Expression filter = t.isDeleted.equals(false);

        if (sector != null && sector != 'Todos') {
          filter = filter & t.sector.ilike('%$sector%');
        }

        if (status != null && status != 'Todos') {
          filter = filter & t.status.equals(status);
        }

        if (temperature != null && temperature != 'Todos') {
          filter = filter & t.temperature.equals(temperature);
        }

        if (advisor != null && advisor != 'Todos') {
          filter = filter & t.advisor.equals(advisor);
        }

        if (search != null && search.trim().isNotEmpty) {
          final q = '%${search.trim()}%';
          final searchExpr =
              t.company.ilike(q) |
              t.address.ilike(q) |
              t.phone.ilike(q) |
              t.contactPerson.ilike(q) |
              t.code.ilike(q);
          filter = filter & searchExpr;
        }

        return filter;
      },
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Obtiene un prospecto específico por su ID primario.
  Future<CrmLead?> getLeadById(int id) async {
    return await CrmLead.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.isDeleted.equals(false),
    );
  }

  /// Registra un nuevo prospecto con código autonumérico secuencial PROSP-XXX.
  Future<CrmLead> createLead(CrmLead lead) async {
    final count = await CrmLead.db.count(session);
    final nextCode = lead.code.isNotEmpty
        ? lead.code
        : 'PROSP-${(count + 1).toString().padLeft(3, '0')}';

    final now = DateTime.now();
    final toInsert = lead.copyWith(
      code: nextCode,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    return await CrmLead.db.insertRow(session, toInsert);
  }

  /// Actualiza los datos generales de un prospecto existente.
  Future<CrmLead> updateLead(CrmLead lead) async {
    final toUpdate = lead.copyWith(updatedAt: DateTime.now());
    return await CrmLead.db.updateRow(session, toUpdate);
  }

  /// Actualiza el estado comercial de un prospecto.
  Future<CrmLead?> updateStatus(int id, String newStatus) async {
    final existing = await getLeadById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    return await CrmLead.db.updateRow(session, updated);
  }

  /// Actualiza la temperatura comercial (Frío, Templado, Caliente).
  Future<CrmLead?> updateTemperature(int id, String newTemp) async {
    final existing = await getLeadById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      temperature: newTemp,
      updatedAt: DateTime.now(),
    );
    return await CrmLead.db.updateRow(session, updated);
  }

  /// Marca un prospecto como promovido a Oportunidad en el Pipeline comercial.
  Future<CrmLead?> markPromoted(int id, int? opportunityId) async {
    final existing = await getLeadById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      isPromoted: true,
      promotedOpportunityId: opportunityId,
      status: 'Interesado (Calificado)',
      temperature: 'Caliente',
      updatedAt: DateTime.now(),
    );
    return await CrmLead.db.updateRow(session, updated);
  }

  /// Realiza la eliminación lógica (Soft Delete) de un prospecto.
  Future<bool> deleteLead(int id) async {
    final existing = await getLeadById(id);
    if (existing == null) return false;

    final updated = existing.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
    await CrmLead.db.updateRow(session, updated);
    return true;
  }

  /// Calcula las métricas agregadas de prospectos en tiempo real.
  Future<CrmLeadMetricsResponse> getMetrics() async {
    final activeLeads = await CrmLead.db.find(
      session,
      where: (t) => t.isDeleted.equals(false),
    );

    final totalCount = activeLeads.length;
    final contactedCount = activeLeads
        .where((l) => l.status == 'Contactado')
        .length;
    final waitingCount = activeLeads
        .where((l) => l.status == 'En Espera de Respuesta')
        .length;
    final qualifiedCount = activeLeads
        .where((l) => l.status == 'Interesado (Calificado)')
        .length;
    final hotCount = activeLeads
        .where((l) => l.temperature == 'Caliente')
        .length;

    final conversionRate = totalCount > 0
        ? (qualifiedCount / totalCount) * 100
        : 0.0;
    final totalPotential = activeLeads
        .where((l) => l.status != 'Descartado')
        .fold<double>(0.0, (acc, l) => acc + l.estimatedValue);

    return CrmLeadMetricsResponse(
      totalCount: totalCount,
      contactedCount: contactedCount,
      waitingCount: waitingCount,
      qualifiedCount: qualifiedCount,
      hotCount: hotCount,
      conversionRate: conversionRate,
      totalPipelinePotential: totalPotential,
    );
  }

  /// Puebla la base de datos con los prospectos reales recopilados de Google Maps si la tabla está vacía.
  Future<void> seedInitialLeadsIfEmpty() async {
    final count = await CrmLead.db.count(
      session,
      where: (t) => t.isDeleted.equals(false),
    );
    if (count > 0) return;

    final now = DateTime.now();
    final seeds = [
      CrmLead(
        code: 'PROSP-001',
        company: 'EMBRIOVID',
        companyUrl: 'https://www.embriovid.com/contactos',
        sector: 'Clínicas y centros médicos',
        advisor: 'Rodrigo Acha',
        address: 'Edif. Tacuaral, Av. San Martín #200, Equipetrol',
        phone: '77042047',
        emailOrWeb: 'https://www.embriovid.com/contactos',
        status: 'En Espera de Respuesta',
        temperature: 'Templado',
        contactPerson: 'Lic. Maria Eugenia (Recepción)',
        notes:
            'Llamada inicial realizada. Recepción consultará con administración el martes para fijar reunión.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      CrmLead(
        code: 'PROSP-002',
        company: 'INSTITUTO DE SALUD REPRODUCTIVA',
        companyUrl: 'https://www.facebook.com/institutosalud',
        sector: 'Clínicas y centros médicos',
        advisor: 'Vanessa Requejo',
        address: 'Barrio Equipetrol Norte Calle "F" Este Esq. Aviador Pinto',
        phone: '77042047',
        emailOrWeb: 'contacto@isr-bolivia.com',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Dr. Alejandro Peña',
        notes:
            'Se envió portafolio institucional de limpieza técnica y desinfección hospitalaria con protocolos biocidas.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-003',
        company: 'GINOFIV',
        companyUrl: 'https://ginofiv.com.bo/',
        sector: 'Clínicas y centros médicos',
        advisor: 'Vanessa Requejo',
        address: 'Av. Alemana calle Sao No 2450 (entre 2do y 3er anillo)',
        phone: '79683941',
        emailOrWeb: 'https://ginofiv.com.bo/',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        contactPerson: 'Ing. Sandra Hurtado (Gerente Operaciones)',
        notes:
            'Solicitaron cotización formal para 2 operarios de limpieza hospitalaria turno matutino y seguridad perimetral.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-004',
        company: 'Clínica Roberto Bacarreza',
        companyUrl: 'https://clinicarobertobacarreza.com/',
        sector: 'Clínicas y centros médicos',
        advisor: 'Rodrigo Acha',
        address:
            'Calle República Dominicana 2068, entre calles Nicaragua y Villalobos',
        phone: '76787767',
        emailOrWeb: 'https://clinicarobertobacarreza.com/',
        status: 'Prospectado',
        temperature: 'Frío',
        contactPerson: 'Administración General',
        notes:
            'Ficha capturada de Google Maps. Pendiente primera llamada de prospección en frío.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-005',
        company: 'Clínica Santa Lucía',
        companyUrl: 'https://www.clinicasantalucia.com',
        sector: 'Clínicas y centros médicos',
        advisor: 'Vanessa Requejo',
        address: 'Av. Salvador esq. Calle J, Zona Norte',
        phone: '3453939',
        emailOrWeb: 'contacto@clinicasantalucia.com',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Dra. Paola Suarez',
        notes:
            'Interesados puntualmente en limpieza profunda de vidrios exteriores en altura y pulido de pisos.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-006',
        company: 'Universal Tours',
        companyUrl: 'https://universaltours.com.bo/',
        sector: 'Corporativo / Oficinas',
        advisor: 'Vanessa Requejo',
        address:
            'Calle Dr. Alberto Seleme Antelo No. 35 (Calle-H), Equipetrol Norte',
        phone: '77360004',
        emailOrWeb: 'https://universaltours.com.bo/',
        status: 'En Espera de Respuesta',
        temperature: 'Templado',
        contactPerson: 'Lic. Fernando Prado',
        notes:
            'Mensaje de WhatsApp enviado directamente al gerente comercial con catálogo de mantenimiento corporativo.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-007',
        company: 'MT Smartravel',
        companyUrl: 'https://www.facebook.com/MTsmartravel',
        sector: 'Corporativo / Oficinas',
        advisor: 'Rodrigo Acha',
        address: 'Edificio YOU Smart Studio, Local 116, Equipetrol Norte',
        phone: '72191071',
        emailOrWeb: 'info@mtsmartravel.bo',
        status: 'Prospectado',
        temperature: 'Frío',
        contactPerson: 'Recepción Central',
        notes:
            'Oficina comercial dentro de complejo de departamentos y corporativos.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-008',
        company: 'CloudIt Bolivia',
        companyUrl: 'https://cloud-it.lat/servicios/',
        sector: 'Corporativo / Oficinas',
        advisor: 'Rodrigo Acha',
        address: 'Calle Pablo Sanz N. 11, Edificio ITAJU, Planta Baja / Sirari',
        phone: '69701255',
        emailOrWeb: 'contacto@cloud-it.lat',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Ing. Rodrigo Justiniano',
        notes:
            'Empresa tecnológica con servidores en sitio. Se coordinará visita para evaluar control de acceso y limpieza técnica.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-009',
        company: 'TLG Landmark Group',
        companyUrl: 'https://tlg.bo/contacto/',
        sector: 'Corporativo / Oficinas',
        advisor: 'Rodrigo Acha',
        address: 'Edificio You Plaza, PB Of. 01, Equipetrol Norte',
        phone: '77351000',
        emailOrWeb: 'https://tlg.bo/contacto/',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        contactPerson: 'Arq. Mario Valverde (Facility Manager)',
        notes:
            'Visita técnica urgente solicitada para mantenimiento preventivo integral y personal de mantenimiento fijo.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 29)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
      CrmLead(
        code: 'PROSP-010',
        company: 'TELIS S.R.L.',
        companyUrl: null,
        sector: 'Corporativo / Oficinas',
        advisor: 'Vanessa Requejo',
        address: 'C. F Nº 144, Barrio Equipetrol',
        phone: '33441541',
        emailOrWeb: 'info@telis.com.bo',
        status: 'Prospectado',
        temperature: 'Frío',
        contactPerson: 'Administración',
        notes:
            'Edificio corporativo con necesidad aparente de jardinería y mantenimiento de fachada.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 23)),
        updatedAt: now.subtract(const Duration(days: 23)),
      ),
      CrmLead(
        code: 'PROSP-011',
        company: 'Colegio Saint Peter Campus Norte',
        companyUrl: 'https://saintpeter.edu.bo',
        sector: 'Colegios & Educación',
        advisor: 'Sara',
        address: 'Km 8 Carretera al Norte, Santa Cruz',
        phone: '78901234',
        emailOrWeb: 'mantenimiento@saintpeter.edu.bo',
        status: 'Interesado (Calificado)',
        temperature: 'Caliente',
        contactPerson: 'Prof. Roberto Cuellar (Administrador)',
        notes:
            'Requieren corte de césped mecanizado quincenal, limpieza de canchas deportivas y portería.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 22)),
        updatedAt: now.subtract(const Duration(days: 22)),
      ),
      CrmLead(
        code: 'PROSP-012',
        company: 'Instituto Técnico Domingo Savio',
        companyUrl: 'https://domingosavio.edu.bo',
        sector: 'Colegios & Educación',
        advisor: 'Juan',
        address: 'Av. Cristo Redentor entre 3er y 4to anillo',
        phone: '3429988',
        emailOrWeb: 'administracion@domingosavio.edu.bo',
        status: 'Contactado',
        temperature: 'Templado',
        contactPerson: 'Lic. Claudia Montero',
        notes:
            'Reunión acordada con el comité de compras para presentar propuesta de limpieza y suministros de papel.',
        estimatedValue: 0.0,
        isPromoted: false,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 21)),
        updatedAt: now.subtract(const Duration(days: 21)),
      ),
    ];

    for (final seed in seeds) {
      await CrmLead.db.insertRow(session, seed);
    }
  }
}
