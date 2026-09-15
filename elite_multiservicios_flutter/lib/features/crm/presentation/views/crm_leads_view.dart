import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modelo de datos para la simulación visual del CRM de Elite Multiservicios.
/// Basado 100% en las columnas de la hoja de cálculo operativa de Google Sheets.
class LeadModel {
  final String id;
  final String date; // Columna A: Fecha de toma
  final String advisor; // Columna B: Asesor
  final String company; // Columna C: Empresa / Edificio
  final String? companyUrl; // Enlace web o Maps asociado a la empresa
  final String sector; // Rubro / Pestaña del Excel (Clínicas, Colegios, etc.)
  final String address; // Columna D: Dirección / Zona
  final String phone; // Columna E: Teléfono(s)
  final String? emailOrWeb; // Columna F: Correo / Web oficial
  final String
  status; // Prospectado, Contactado, En Espera, Interesado, Rechazado
  final String? notes;

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
    this.notes,
  });

  LeadModel copyWith({
    String? status,
    String? notes,
  }) {
    return LeadModel(
      id: id,
      date: date,
      advisor: advisor,
      company: company,
      companyUrl: companyUrl,
      sector: sector,
      address: address,
      phone: phone,
      emailOrWeb: emailOrWeb,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

/// Vista interactiva del submódulo de Prospectos / Prospección en Google Maps.
class CrmLeadsView extends StatefulWidget {
  const CrmLeadsView({super.key});

  @override
  State<CrmLeadsView> createState() => _CrmLeadsViewState();
}

class _CrmLeadsViewState extends State<CrmLeadsView> {
  String _searchQuery = '';
  String _selectedSector = 'Todos';
  String _selectedAdvisor = 'Todos';
  String _selectedStatus = 'Todos';
  bool _isTableView =
      false; // Alternar entre Vista Tarjetas (Grid) y Vista Tabla

  // Datos reales extraídos de la hoja de cálculo del equipo comercial
  final List<LeadModel> _leads = [
    const LeadModel(
      id: 'PROSP-001',
      date: '18/08/2026',
      advisor: 'Rodrigo Acha',
      company: 'EMBRIOVID',
      companyUrl: 'https://www.embriovid.com/contactos',
      sector: 'Clínicas y centros médicos',
      address: 'Edif. Tacuaral, Av. San Martín',
      phone: '77042047',
      emailOrWeb: 'https://www.embriovid.com/contactos',
      status: 'En Espera de Respuesta',
      notes:
          'Llamada inicial realizada. Recepción consultará con administración el martes.',
    ),
    const LeadModel(
      id: 'PROSP-002',
      date: '19/08/2026',
      advisor: 'Vanessa Requejo',
      company: 'INSTITUTO DE SALUD REPRODUCTIVA',
      companyUrl: 'https://www.facebook.com/institutosalud',
      sector: 'Clínicas y centros médicos',
      address: 'Barrio Equipetrol Norte Calle "F" Este Esq. Aviador Pinto',
      phone: '77042047 - 3 3448899',
      emailOrWeb: 'https://www.facebook.com/institutosalud',
      status: 'Contactado',
      notes: 'Se envió portafolio de limpieza y desinfección hospitalaria.',
    ),
    const LeadModel(
      id: 'PROSP-003',
      date: '19/08/2026',
      advisor: 'Vanessa Requejo',
      company: 'GINOFIV',
      companyUrl: 'https://ginofiv.com.bo/',
      sector: 'Clínicas y centros médicos',
      address: 'Av. Alemana calle Sao No 2450 (entre 3er y 2do anillo)',
      phone: '79683941 - 79683943',
      emailOrWeb: 'https://ginofiv.com.bo/',
      status: 'Interesado (Calificado)',
      notes:
          'Solicitaron cotización para 2 guardias nocturnos y limpieza general.',
    ),
    const LeadModel(
      id: 'PROSP-004',
      date: '19/08/2026',
      advisor: 'Rodrigo Acha',
      company: 'Clínica Roberto Bacarreza',
      companyUrl: 'https://clinicarobertobacarreza.com/',
      sector: 'Clínicas y centros médicos',
      address:
          'Calle República Dominicana 2068, entre calles Nicaragua y Villalobos',
      phone: '76787767 - 77550001',
      emailOrWeb: 'https://clinicarobertobacarreza.com/',
      status: 'Prospectado',
      notes: 'Encontrado en Google Maps. Pendiente primera llamada.',
    ),
    const LeadModel(
      id: 'PROSP-005',
      date: '19/08/2026',
      advisor: 'Vanessa Requejo',
      company: 'Clínica Santa Lucía',
      companyUrl: 'https://www.clinicasantalucia.com',
      sector: 'Clínicas y centros médicos',
      address: 'Av. Salvador esq. Calle J',
      phone: '3453939',
      emailOrWeb: 'contacto@clinicasantalucia.com',
      status: 'Contactado',
      notes: 'Interesados en limpieza de vidrios exteriores.',
    ),
    const LeadModel(
      id: 'PROSP-006',
      date: '19/08/2026',
      advisor: 'Vanessa Requejo',
      company: 'Universal Tours',
      companyUrl: 'https://universaltours.com.bo/',
      sector: 'Corporativo / Oficinas',
      address:
          'Calle Dr. Alberto Seleme Antelo No. 35 (Calle-H), Equipetrol Norte',
      phone: '344-9777 o 77360004',
      emailOrWeb: 'https://universaltours.com.bo/',
      status: 'En Espera de Respuesta',
      notes: 'Mensaje de WhatsApp enviado al gerente comercial.',
    ),
    const LeadModel(
      id: 'PROSP-007',
      date: '19/08/2026',
      advisor: 'Rodrigo Acha',
      company: 'MT Smartravel',
      companyUrl: 'https://www.facebook.com/MTsmartravel',
      sector: 'Corporativo / Oficinas',
      address: 'ZONA EQUIPETROL NORTE - Edificio YOU Smart Studio, Local 116',
      phone: '72191071',
      emailOrWeb: 'info@mtsmartravel.bo',
      status: 'Prospectado',
      notes: 'Ubicado en Edificio YOU Smart Studio.',
    ),
    const LeadModel(
      id: 'PROSP-008',
      date: '19/08/2026',
      advisor: 'Rodrigo Acha',
      company: 'CloudIt',
      companyUrl: 'https://cloud-it.lat/servicios/',
      sector: 'Corporativo / Oficinas',
      address: 'Calle Pablo Sanz N. 11, Edificio ITAJU, planta baja / Sirari',
      phone: '697 01255 - 697 01637',
      emailOrWeb: 'https://cloud-it.lat/servicios/',
      status: 'Contactado',
      notes:
          'Empresa tecnológica. Se ofreció seguridad electrónica y soporte IT.',
    ),
    const LeadModel(
      id: 'PROSP-009',
      date: '19/08/2026',
      advisor: 'Rodrigo Acha',
      company: 'tlg Landmark Group',
      companyUrl: 'https://tlg.bo/contacto/',
      sector: 'Corporativo / Oficinas',
      address: 'Edificio You Plaza, Pb Of 01 Equipetrol Norte',
      phone: '62010393 - 77351000',
      emailOrWeb: 'https://tlg.bo/contacto/',
      status: 'Interesado (Calificado)',
      notes:
          'Visita técnica solicitada para mantenimiento preventivo del edificio.',
    ),
    const LeadModel(
      id: 'PROSP-010',
      date: '25/08/2026',
      advisor: 'Vanessa Requejo',
      company: 'TELIS S.R.L.',
      companyUrl: null,
      sector: 'Corporativo / Oficinas',
      address: 'C. F Nº 144, Equipetrol',
      phone: '33441541',
      emailOrWeb: 'info@telis.com.bo',
      status: 'Prospectado',
      notes: 'Datos obtenidos de fachada en Google Maps.',
    ),
    const LeadModel(
      id: 'PROSP-011',
      date: '26/08/2026',
      advisor: 'Sara',
      company: 'Colegio Saint Peter Campus Norte',
      companyUrl: 'https://saintpeter.edu.bo',
      sector: 'Colegios',
      address: 'Km 8 Carretera al Norte, Santa Cruz',
      phone: '789-01234',
      emailOrWeb: 'mantenimiento@saintpeter.edu.bo',
      status: 'Interesado (Calificado)',
      notes:
          'Corte de pasto, jardinería perimetral y limpieza general de canchas.',
    ),
    const LeadModel(
      id: 'PROSP-012',
      date: '27/08/2026',
      advisor: 'Juan',
      company: 'Instituto Técnico Domingo Savio',
      companyUrl: 'https://domingosavio.edu.bo',
      sector: 'Institutos',
      address: 'Av. Cristo Redentor entre 3er y 4to anillo',
      phone: '342-9988',
      emailOrWeb: 'administracion@domingosavio.edu.bo',
      status: 'Contactado',
      notes: 'Reunión acordada con el jefe de compras.',
    ),
  ];

  final List<String> _sectors = [
    'Todos',
    'Clínicas y centros médicos',
    'Colegios',
    'Institutos',
    'Corporativo / Oficinas',
  ];

  final List<String> _advisors = [
    'Todos',
    'Rodrigo Acha',
    'Vanessa Requejo',
    'Sara',
    'Juan',
    'Paola',
  ];

  final List<String> _statuses = [
    'Todos',
    'Prospectado',
    'Contactado',
    'En Espera de Respuesta',
    'Interesado (Calificado)',
    'Descartado',
  ];

  List<LeadModel> get _filteredLeads {
    return _leads.where((item) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          item.company.toLowerCase().contains(q) ||
          item.address.toLowerCase().contains(q) ||
          item.phone.contains(q) ||
          item.advisor.toLowerCase().contains(q);

      final matchesSector =
          _selectedSector == 'Todos' || item.sector == _selectedSector;
      final matchesAdvisor =
          _selectedAdvisor == 'Todos' || item.advisor == _selectedAdvisor;
      final matchesStatus =
          _selectedStatus == 'Todos' || item.status == _selectedStatus;

      return matchesSearch && matchesSector && matchesAdvisor && matchesStatus;
    }).toList();
  }

  Color _getStatusColor(String status, bool isDark) {
    switch (status) {
      case 'Prospectado':
        return const Color(0xFF64748B);
      case 'Contactado':
        return const Color(0xFF3B82F6);
      case 'En Espera de Respuesta':
        return const Color(0xFFF59E0B);
      case 'Interesado (Calificado)':
        return const Color(0xFF10B981);
      case 'Descartado':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1400),
        backgroundColor: const Color(0xFF0F172A),
        content: Text('$label copiado al portapapeles: $text'),
      ),
    );
  }

  void _updateStatus(LeadModel lead, String newStatus) {
    final idx = _leads.indexWhere((l) => l.id == lead.id);
    if (idx != -1) {
      setState(() {
        _leads[idx] = lead.copyWith(status: newStatus);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1200),
          backgroundColor: const Color(0xFF065F46),
          content: Text(
            'Estado de "${lead.company}" actualizado a: $newStatus',
          ),
        ),
      );
    }
  }

  void _showNewLeadDialog() {
    final companyCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String sectorVal = 'Clínicas y centros médicos';
    String advisorVal = 'Rodrigo Acha';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuevo Prospecto (Google Maps / Outbound)',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Copia los datos de la ficha de Maps al sistema',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RUBRO / SECTOR',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: sectorVal,
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                              items: _sectors
                                  .where((s) => s != 'Todos')
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s,
                                        style: GoogleFonts.inter(fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) sectorVal = v;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ASESOR ASIGNADO',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: advisorVal,
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                              items: _advisors
                                  .where((a) => a != 'Todos')
                                  .map(
                                    (a) => DropdownMenuItem(
                                      value: a,
                                      child: Text(
                                        a,
                                        style: GoogleFonts.inter(fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) advisorVal = v;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'EMPRESA / NOMBRE DEL EDIFICIO O NEGOCIO',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: companyCtrl,
                    decoration: InputDecoration(
                      hintText: 'Ej. Torre Delta, Clínica Roberto Bacarreza',
                      hintStyle: GoogleFonts.inter(fontSize: 12.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'DIRECCIÓN / ZONA (COPIAR DE GOOGLE MAPS)',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: addressCtrl,
                    decoration: InputDecoration(
                      hintText:
                          'Ej. Av. San Martín, Edif. Tacuaral / Equipetrol Norte',
                      hintStyle: GoogleFonts.inter(fontSize: 12.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TELÉFONO(S) / WHATSAPP',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: phoneCtrl,
                              decoration: InputDecoration(
                                hintText: '77042047, 3 3448899...',
                                hintStyle: GoogleFonts.inter(fontSize: 12.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CORREO / WEB / ENLACE DE MAPS',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: urlCtrl,
                              decoration: InputDecoration(
                                hintText: 'https://... o contacto@...',
                                hintStyle: GoogleFonts.inter(fontSize: 12.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'NOTAS DE PROSPECCIÓN / OBSERVACIONES',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          'Detalles del servicio que se le puede ofrecer...',
                      hintStyle: GoogleFonts.inter(fontSize: 12.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                if (companyCtrl.text.isNotEmpty) {
                  setState(() {
                    _leads.insert(
                      0,
                      LeadModel(
                        id: 'PROSP-${(_leads.length + 1).toString().padLeft(3, '0')}',
                        date: 'Hoy, 14/09/2026',
                        advisor: advisorVal,
                        company: companyCtrl.text.trim(),
                        companyUrl: urlCtrl.text.trim().isNotEmpty
                            ? urlCtrl.text.trim()
                            : null,
                        sector: sectorVal,
                        address: addressCtrl.text.trim().isNotEmpty
                            ? addressCtrl.text.trim()
                            : 'Santa Cruz de la Sierra',
                        phone: phoneCtrl.text.trim().isNotEmpty
                            ? phoneCtrl.text.trim()
                            : 'Sin teléfono registrado',
                        emailOrWeb: urlCtrl.text.trim().isNotEmpty
                            ? urlCtrl.text.trim()
                            : null,
                        status: 'Prospectado',
                        notes: notesCtrl.text.trim().isNotEmpty
                            ? notesCtrl.text.trim()
                            : 'Recién recopilado de Google Maps.',
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF065F46),
                      content: Text('Nuevo prospecto añadido exitosamente.'),
                    ),
                  );
                }
              },
              child: Text(
                'Guardar Prospecto',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredLeads;

    final totalProspectos = _leads.length;
    final contactados = _leads.where((l) => l.status == 'Contactado').length;
    final enEspera = _leads
        .where((l) => l.status == 'En Espera de Respuesta')
        .length;
    final interesados = _leads
        .where((l) => l.status == 'Interesado (Calificado)')
        .length;

    return LayoutBuilder(
      builder: (context, rootConstraints) {
        final isMobile = rootConstraints.maxWidth < 650;
        final hPad = isMobile ? 12.0 : 24.0;
        final vPad = isMobile ? 14.0 : 24.0;

        final titleColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'CRM OPERATIVO',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Text(
                  'Prospección Outbound / Google Maps',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Prospectos & Clientes Potenciales',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 19 : 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Reemplazo inteligente del Excel comercial con trazabilidad por asesor y rubro.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        );

        final newLeadButton = ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
          ),
          onPressed: _showNewLeadDialog,
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Nuevo Prospecto',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header estilo ERP Ejecutivo adaptativo
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleColumn,
                    const SizedBox(height: 12),
                    newLeadButton,
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: titleColumn),
                    const SizedBox(width: 16),
                    newLeadButton,
                  ],
                ),

              const SizedBox(height: 20),

              // 2. Tarjetas de Resumen KPI (Distribuidas equitativamente ocupando el 100% del ancho)
              LayoutBuilder(
                builder: (context, box) {
                  final isWide = box.maxWidth > 950;
                  final isTablet = box.maxWidth > 550;

                  if (isWide) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Total en Lista',
                            value: '$totalProspectos',
                            subtitle: 'Prospectos recopilados',
                            icon: Icons.list_alt,
                            accentColor: const Color(0xFF3B82F6),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Contactados',
                            value: '$contactados',
                            subtitle: 'Primer contacto hecho',
                            icon: Icons.phone_forwarded,
                            accentColor: const Color(0xFF6366F1),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'En Espera',
                            value: '$enEspera',
                            subtitle: 'Pendientes de respuesta',
                            icon: Icons.pending_actions,
                            accentColor: const Color(0xFFF59E0B),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'Interesados',
                            value: '$interesados',
                            subtitle: 'Listos para cotizar',
                            icon: Icons.verified,
                            accentColor: const Color(0xFF10B981),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    );
                  } else if (isTablet) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildKpiCard(
                                title: 'Total en Lista',
                                value: '$totalProspectos',
                                subtitle: 'Prospectos recopilados',
                                icon: Icons.list_alt,
                                accentColor: const Color(0xFF3B82F6),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildKpiCard(
                                title: 'Contactados',
                                value: '$contactados',
                                subtitle: 'Primer contacto hecho',
                                icon: Icons.phone_forwarded,
                                accentColor: const Color(0xFF6366F1),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildKpiCard(
                                title: 'En Espera',
                                value: '$enEspera',
                                subtitle: 'Pendientes de respuesta',
                                icon: Icons.pending_actions,
                                accentColor: const Color(0xFFF59E0B),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildKpiCard(
                                title: 'Interesados',
                                value: '$interesados',
                                subtitle: 'Listos para cotizar',
                                icon: Icons.verified,
                                accentColor: const Color(0xFF10B981),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildKpiCard(
                          title: 'Total en Lista',
                          value: '$totalProspectos',
                          subtitle: 'Prospectos recopilados',
                          icon: Icons.list_alt,
                          accentColor: const Color(0xFF3B82F6),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _buildKpiCard(
                          title: 'Contactados',
                          value: '$contactados',
                          subtitle: 'Primer contacto hecho',
                          icon: Icons.phone_forwarded,
                          accentColor: const Color(0xFF6366F1),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _buildKpiCard(
                          title: 'En Espera',
                          value: '$enEspera',
                          subtitle: 'Pendientes de respuesta',
                          icon: Icons.pending_actions,
                          accentColor: const Color(0xFFF59E0B),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _buildKpiCard(
                          title: 'Interesados',
                          value: '$interesados',
                          subtitle: 'Listos para cotizar',
                          icon: Icons.verified,
                          accentColor: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 24),

              // 3. Pestañas de Rubro (Reemplaza las pestañas de abajo del Excel)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _sectors.map((sec) {
                    final isSelected = _selectedSector == sec;
                    final count = sec == 'Todos'
                        ? _leads.length
                        : _leads.where((l) => l.sector == sec).length;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(sec),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF64748B)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B)),
                        ),
                        selectedColor: const Color(0xFF10B981),
                        backgroundColor: isDark
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF10B981)
                                : (isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        onSelected: (sel) {
                          if (sel) setState(() => _selectedSector = sec);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 14),

              // 4. Barra de Búsqueda y Filtros totalmente organizada y equilibrada
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, box) {
                    final isWide = box.maxWidth > 800;

                    final searchField = TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Buscar por empresa, dirección, teléfono...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    );

                    final advisorDropdown = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedAdvisor,
                          isExpanded: true,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                            fontWeight: FontWeight.w500,
                          ),
                          dropdownColor: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          items: _advisors
                              .map(
                                (adv) => DropdownMenuItem(
                                  value: adv,
                                  child: Text(
                                    'Asesor: $adv',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedAdvisor = val);
                            }
                          },
                        ),
                      ),
                    );

                    final statusDropdown = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          isExpanded: true,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                            fontWeight: FontWeight.w500,
                          ),
                          dropdownColor: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          items: _statuses
                              .map(
                                (st) => DropdownMenuItem(
                                  value: st,
                                  child: Text(
                                    'Estado: $st',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedStatus = val);
                            }
                          },
                        ),
                      ),
                    );

                    final viewToggle = Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161F30)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.grid_view_rounded,
                              size: 18,
                              color: !_isTableView
                                  ? const Color(0xFF10B981)
                                  : (isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8)),
                            ),
                            tooltip: 'Vista Cuadrícula',
                            onPressed: () =>
                                setState(() => _isTableView = false),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.table_rows_rounded,
                              size: 18,
                              color: _isTableView
                                  ? const Color(0xFF10B981)
                                  : (isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8)),
                            ),
                            tooltip: 'Vista Hoja de Cálculo',
                            onPressed: () =>
                                setState(() => _isTableView = true),
                          ),
                        ],
                      ),
                    );

                    if (isWide) {
                      return Row(
                        children: [
                          Expanded(child: searchField),
                          const SizedBox(width: 12),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 190),
                            child: advisorDropdown,
                          ),
                          const SizedBox(width: 12),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 210),
                            child: statusDropdown,
                          ),
                          const SizedBox(width: 12),
                          viewToggle,
                        ],
                      );
                    } else if (box.maxWidth > 560) {
                      return Column(
                        children: [
                          searchField,
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: advisorDropdown),
                              const SizedBox(width: 8),
                              Expanded(child: statusDropdown),
                              const SizedBox(width: 8),
                              viewToggle,
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          searchField,
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: advisorDropdown),
                              const SizedBox(width: 8),
                              Expanded(child: statusDropdown),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: viewToggle,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 5. Contenido Principal: Cuadrícula Equilibrada o Tabla de Alta Densidad
              if (filtered.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 40,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No se encontraron prospectos con los filtros actuales',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_isTableView)
                _buildTableView(filtered, isDark)
              else
                _buildGridView(filtered, isDark),
            ],
          ),
        );
      },
    );
  }

  // Vista en Cuadrícula Responsiva (2 columnas en escritorio)
  Widget _buildGridView(List<LeadModel> filtered, bool isDark) {
    return LayoutBuilder(
      builder: (context, box) {
        final isTwoCol = box.maxWidth > 850;

        if (isTwoCol) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 225,
            ),
            itemBuilder: (context, idx) {
              return _buildLeadCard(filtered[idx], isDark);
            },
          );
        } else {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              return _buildLeadCard(filtered[idx], isDark);
            },
          );
        }
      },
    );
  }

  // Tarjeta Individual con Proporción Equilibrada
  Widget _buildLeadCard(LeadModel item, bool isDark) {
    final statusCol = _getStatusColor(item.status, isDark);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la Tarjeta
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.company,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.sector,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Text(
                          item.advisor,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Selector de Estado
              PopupMenuButton<String>(
                tooltip: 'Cambiar estado',
                onSelected: (newSt) => _updateStatus(item, newSt),
                itemBuilder: (ctx) =>
                    [
                          'Prospectado',
                          'Contactado',
                          'En Espera de Respuesta',
                          'Interesado (Calificado)',
                          'Descartado',
                        ]
                        .map(
                          (s) => PopupMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(s, isDark),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(s, style: GoogleFonts.inter(fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusCol.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusCol.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusCol,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 130),
                        child: Text(
                          item.status,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: statusCol,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_drop_down, size: 14, color: statusCol),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Dirección
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.address,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF334155),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => _copyToClipboard(item.address, 'Dirección'),
                child: const Icon(
                  Icons.copy,
                  size: 13,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Teléfono y Web
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 15,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.phone,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.content_copy, size: 13),
                    tooltip: 'Copiar teléfono',
                    visualDensity: VisualDensity.compact,
                    color: const Color(0xFF64748B),
                    onPressed: () => _copyToClipboard(item.phone, 'Teléfono'),
                  ),
                ],
              ),
              if (item.emailOrWeb != null)
                InkWell(
                  onTap: () => _copyToClipboard(item.emailOrWeb!, 'Enlace Web'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.link,
                        size: 13,
                        color: Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sitio Web',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF8B5CF6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Nota de seguimiento
          if (item.notes != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161F30)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                'Nota: ${item.notes!}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Vista Tabla Tipo Hoja de Cálculo (Máxima Densidad y Alineación)
  Widget _buildTableView(List<LeadModel> items, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF161F30) : const Color(0xFFF8FAFC),
            ),
            dataRowMaxHeight: 52,
            columnSpacing: 24,
            columns: [
              DataColumn(
                label: Text(
                  'EMPRESA / NEGOCIO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'RUBRO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ASESOR',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'DIRECCIÓN EN MAPS',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'TELÉFONO(S)',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ESTADO',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ACCIONES',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
            rows: items.map((item) {
              final statusCol = _getStatusColor(item.status, isDark);
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      item.company,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.sector,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.advisor,
                      style: GoogleFonts.inter(fontSize: 11.5),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 240),
                          child: Text(
                            item.address,
                            style: GoogleFonts.inter(fontSize: 11.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 12,
                            color: Color(0xFF3B82F6),
                          ),
                          tooltip: 'Copiar dirección',
                          onPressed: () =>
                              _copyToClipboard(item.address, 'Dirección'),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.phone,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.content_copy, size: 12),
                          tooltip: 'Copiar teléfono',
                          onPressed: () =>
                              _copyToClipboard(item.phone, 'Teléfono'),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusCol.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: statusCol.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        item.status,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: statusCol,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButton<String>(
                      tooltip: 'Cambiar estado',
                      onSelected: (newSt) => _updateStatus(item, newSt),
                      itemBuilder: (ctx) =>
                          [
                                'Prospectado',
                                'Contactado',
                                'En Espera de Respuesta',
                                'Interesado (Calificado)',
                                'Descartado',
                              ]
                              .map(
                                (s) => PopupMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                      child: const Icon(
                        Icons.edit_note,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Tarjeta de KPI Flexible
  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
