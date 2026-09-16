import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/crm_customers_service.dart';

/// Modelo local de Línea de Cotización para desglose operativo y propuesta comercial.
class QuoteItem {
  final String id;
  final String
  category; // 'Personal', 'Limpieza', 'Mantenimiento', 'Equipamiento', 'Materiales', 'Tecnología'
  final String concept;
  final String
  unitType; // 'Puesto 24/7', 'Puesto 12h', 'Operario', 'Global', 'm²', 'Unid.', 'Servicio', 'Kit', 'Tanque'
  final double quantity;
  final double unitPrice;

  const QuoteItem({
    required this.id,
    required this.category,
    required this.concept,
    required this.unitType,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  QuoteItem copyWith({
    String? id,
    String? category,
    String? concept,
    String? unitType,
    double? quantity,
    double? unitPrice,
  }) {
    return QuoteItem(
      id: id ?? this.id,
      category: category ?? this.category,
      concept: concept ?? this.concept,
      unitType: unitType ?? this.unitType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

/// Modelo local de Oportunidad Comercial para el Pipeline y Kanban.
class OpportunityItem {
  final String id;
  final String title;
  final String clientName;
  final String contactPerson;
  final String phone;
  final String serviceType;
  final double amount;
  final String
  stage; // 'Calificación', 'Visita Técnica', 'Propuesta', 'Negociación', 'Ganada'
  final int probability; // 0 - 100
  final String owner;
  final String closingDate;
  final String notes;
  final String
  contractType; // 'Proyecto Único', 'Recurrente Mensual', 'Servicio por Evento', 'Híbrido'
  final String
  executionTime; // Ej: '7 días hábiles', 'Contrato 12 meses', '15 días + Abono'
  final String
  paymentTerms; // Ej: '50% Anticipo / 50% Recepción Conforme', 'Facturación mensual a 30 días'
  final int advancePercentage; // 0, 30, 50, 70, 100
  final List<QuoteItem> quoteItems;

  // Compuerta 1: Perfil del Decisor & Segmento
  final String contactRole;
  final String businessSegment;

  // Compuerta 2: Sede Operativa de Inspección (Visita Técnica)
  final String siteName;
  final String siteAddress;
  final String siteCity;
  final String siteContactName;
  final String siteContactPhone;
  final String siteAccessRequirements;
  final bool isSiteHeadquarters;

  // Compuerta 3: Datos Fiscales & Minuta Legal (Negociación)
  final String legalBusinessName;
  final String taxId;
  final String legalRepresentative;
  final String billingEmail;

  // Compuerta 4: Cierre Formal & Traspaso (Ganada)
  final String serviceStartDate;
  final double advancePaid;
  final String wonNotes;

  const OpportunityItem({
    required this.id,
    required this.title,
    required this.clientName,
    required this.contactPerson,
    required this.phone,
    required this.serviceType,
    required this.amount,
    required this.stage,
    required this.probability,
    required this.owner,
    required this.closingDate,
    required this.notes,
    this.contractType = 'Recurrente Mensual',
    this.executionTime = '12 meses',
    this.paymentTerms = 'Facturación mensual a 30 días',
    this.advancePercentage = 0,
    this.quoteItems = const [],
    this.contactRole = 'Administrador',
    this.businessSegment = 'Corporativo B2B',
    this.siteName = '',
    this.siteAddress = '',
    this.siteCity = 'Santa Cruz',
    this.siteContactName = '',
    this.siteContactPhone = '',
    this.siteAccessRequirements = '',
    this.isSiteHeadquarters = true,
    this.legalBusinessName = '',
    this.taxId = '',
    this.legalRepresentative = '',
    this.billingEmail = '',
    this.serviceStartDate = '',
    this.advancePaid = 0.0,
    this.wonNotes = '',
  });

  OpportunityItem copyWith({
    String? stage,
    int? probability,
    String? notes,
    double? amount,
    String? contractType,
    String? executionTime,
    String? paymentTerms,
    int? advancePercentage,
    List<QuoteItem>? quoteItems,
    String? contactRole,
    String? businessSegment,
    String? siteName,
    String? siteAddress,
    String? siteCity,
    String? siteContactName,
    String? siteContactPhone,
    String? siteAccessRequirements,
    bool? isSiteHeadquarters,
    String? legalBusinessName,
    String? taxId,
    String? legalRepresentative,
    String? billingEmail,
    String? serviceStartDate,
    double? advancePaid,
    String? wonNotes,
  }) {
    final newQuoteItems = quoteItems ?? this.quoteItems;
    final newAmount =
        amount ??
        (quoteItems != null
            ? quoteItems.fold<double>(0.0, (acc, q) => acc + q.subtotal)
            : this.amount);

    return OpportunityItem(
      id: id,
      title: title,
      clientName: clientName,
      contactPerson: contactPerson,
      phone: phone,
      serviceType: serviceType,
      amount: newAmount,
      stage: stage ?? this.stage,
      probability: probability ?? this.probability,
      owner: owner,
      closingDate: closingDate,
      notes: notes ?? this.notes,
      contractType: contractType ?? this.contractType,
      executionTime: executionTime ?? this.executionTime,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      quoteItems: newQuoteItems,
      contactRole: contactRole ?? this.contactRole,
      businessSegment: businessSegment ?? this.businessSegment,
      siteName: siteName ?? this.siteName,
      siteAddress: siteAddress ?? this.siteAddress,
      siteCity: siteCity ?? this.siteCity,
      siteContactName: siteContactName ?? this.siteContactName,
      siteContactPhone: siteContactPhone ?? this.siteContactPhone,
      siteAccessRequirements:
          siteAccessRequirements ?? this.siteAccessRequirements,
      isSiteHeadquarters: isSiteHeadquarters ?? this.isSiteHeadquarters,
      legalBusinessName: legalBusinessName ?? this.legalBusinessName,
      taxId: taxId ?? this.taxId,
      legalRepresentative: legalRepresentative ?? this.legalRepresentative,
      billingEmail: billingEmail ?? this.billingEmail,
      serviceStartDate: serviceStartDate ?? this.serviceStartDate,
      advancePaid: advancePaid ?? this.advancePaid,
      wonNotes: wonNotes ?? this.wonNotes,
    );
  }
}

/// Vista interactiva del Tablero Kanban y Embudo Comercial (Pipeline).
class CrmPipelineView extends StatefulWidget {
  const CrmPipelineView({super.key});

  @override
  State<CrmPipelineView> createState() => _CrmPipelineViewState();
}

class _CrmPipelineViewState extends State<CrmPipelineView> {
  final List<String> _stages = const [
    'Calificación',
    'Visita Técnica',
    'Propuesta',
    'Negociación',
    'Ganada',
  ];

  String _searchQuery = '';
  String _selectedService = 'Todos';
  String _selectedOwner = 'Todos';
  String _activeMobileStage = 'Calificación';
  bool _isListView = false;

  final List<OpportunityItem> _deals = [
    const OpportunityItem(
      id: 'OPP-101',
      title: 'Seguridad Perimetral 24/7 (3 Puestos)',
      clientName: 'Condominio Las Palmas Real',
      contactPerson: 'Lic. Marcelo Justiniano',
      phone: '77312890',
      serviceType: 'Seguridad',
      amount: 14500.0,
      stage: 'Visita Técnica',
      probability: 60,
      owner: 'Carlos V.',
      closingDate: '30 Sep 2026',
      notes:
          'Visita técnica programada para inspeccionar garitas de ingreso y cerco perimétrico.',
      contractType: 'Recurrente Mensual',
      executionTime: 'Contrato 12 meses renovable',
      paymentTerms: 'Facturación mensual contra planilla',
      advancePercentage: 0,
      quoteItems: [
        QuoteItem(
          id: 'Q-101-1',
          category: 'Personal',
          concept: 'Puesto Vigilancia 24/7 (Turnos rotativos 12h, 3 guardias)',
          unitType: 'Puesto 24/7',
          quantity: 2,
          unitPrice: 6800.0,
        ),
        QuoteItem(
          id: 'Q-101-2',
          category: 'Equipamiento',
          concept: 'Kit Radios VHF Motorola + Base y baterías de respaldo',
          unitType: 'Kit',
          quantity: 1,
          unitPrice: 500.0,
        ),
        QuoteItem(
          id: 'Q-101-3',
          category: 'Tecnología',
          concept: 'Rondín Electrónico RFID con reporte en tiempo real y GPS',
          unitType: 'Servicio',
          quantity: 1,
          unitPrice: 400.0,
        ),
      ],
    ),
    const OpportunityItem(
      id: 'OPP-102',
      title: 'Mantenimiento y Reparación de Grupo Electrógeno y Tanques',
      clientName: 'Edificio Titanium',
      contactPerson: 'Ing. Fernando Vaca',
      phone: '76045122',
      serviceType: 'Mantenimiento',
      amount: 9800.0,
      stage: 'Propuesta',
      probability: 70,
      owner: 'Elena R.',
      closingDate: '25 Sep 2026',
      notes:
          'Proyecto por obra cerrada. Requieren 50% anticipo para adquisición de insumos y filtros.',
      contractType: 'Proyecto Único',
      executionTime: '7 días hábiles',
      paymentTerms: '50% Anticipo / 50% Recepción Conforme',
      advancePercentage: 50,
      quoteItems: [
        QuoteItem(
          id: 'Q-102-1',
          category: 'Mantenimiento',
          concept: 'Mantenimiento Preventivo y Calibración Grupo Electrógeno',
          unitType: 'Global',
          quantity: 1,
          unitPrice: 4200.0,
        ),
        QuoteItem(
          id: 'Q-102-2',
          category: 'Limpieza',
          concept: 'Lavado y Desinfección Profunda de Tanques de Agua Potable',
          unitType: 'Tanque',
          quantity: 2,
          unitPrice: 1800.0,
        ),
        QuoteItem(
          id: 'Q-102-3',
          category: 'Materiales',
          concept: 'Kit Filtros, Aceite Sintético y Repuestos Certificados',
          unitType: 'Kit',
          quantity: 1,
          unitPrice: 2000.0,
        ),
      ],
    ),
    const OpportunityItem(
      id: 'OPP-103',
      title: 'Limpieza Hospitalaria Especializada Integral',
      clientName: 'Clínica Santa María',
      contactPerson: 'Dra. Vanessa Saucedo',
      phone: '78019344',
      serviceType: 'Limpieza',
      amount: 18200.0,
      stage: 'Negociación',
      probability: 85,
      owner: 'Carlos V.',
      closingDate: '20 Sep 2026',
      notes:
          'Revisión final de cláusulas contractuales y cronograma de turnos nocturnos.',
      contractType: 'Recurrente Mensual',
      executionTime: 'Contrato 12 meses',
      paymentTerms: 'Facturación mensual a 30 días',
      advancePercentage: 0,
      quoteItems: [
        QuoteItem(
          id: 'Q-103-1',
          category: 'Personal',
          concept:
              'Operario Limpieza Hospitalaria Especializada (Diurno/Nocturno)',
          unitType: 'Operario',
          quantity: 4,
          unitPrice: 3800.0,
        ),
        QuoteItem(
          id: 'Q-103-2',
          category: 'Materiales',
          concept:
              'Insumos y Químicos Desinfectantes Hospitalarios Certificados',
          unitType: 'Mes',
          quantity: 1,
          unitPrice: 3000.0,
        ),
      ],
    ),
    const OpportunityItem(
      id: 'OPP-104',
      title: 'Instalación CCTV 4K IA + Monitoreo Perimétrico Continuo',
      clientName: 'TechLogistics Bolivia',
      contactPerson: 'Ramiro Peinado',
      phone: '71089233',
      serviceType: 'Software',
      amount: 32000.0,
      stage: 'Calificación',
      probability: 30,
      owner: 'Rogelio A.',
      closingDate: '15 Oct 2026',
      notes:
          'Modelo híbrido: Suministro de hardware e instalación inicial (Bs. 27,000) + Abono mensual de soporte y monitoreo (Bs. 5,000/mes).',
      contractType: 'Híbrido',
      executionTime: '15 días instalación + Abono mensual',
      paymentTerms: 'Equipamiento al contado / Monitoreo mensual',
      advancePercentage: 50,
      quoteItems: [
        QuoteItem(
          id: 'Q-104-1',
          category: 'Tecnología',
          concept: 'Cámara IP Dahua 4K IA con Reconocimiento Facial y LPR',
          unitType: 'Unid.',
          quantity: 8,
          unitPrice: 2500.0,
        ),
        QuoteItem(
          id: 'Q-104-2',
          category: 'Equipamiento',
          concept:
              'Servidor NVR 32 Canales + 8TB Almacenamiento Grado Seguridad',
          unitType: 'Unid.',
          quantity: 1,
          unitPrice: 7000.0,
        ),
        QuoteItem(
          id: 'Q-104-3',
          category: 'Tecnología',
          concept:
              'Licencia e Integración Software Control de Accesos y Monitoreo',
          unitType: 'Global',
          quantity: 1,
          unitPrice: 5000.0,
        ),
      ],
    ),
    const OpportunityItem(
      id: 'OPP-105',
      title: 'Paisajismo y Jardinería Corporativa',
      clientName: 'Colegio Saint Peter',
      contactPerson: 'Lic. Claudia Montero',
      phone: '75034119',
      serviceType: 'Jardinería',
      amount: 5400.0,
      stage: 'Ganada',
      probability: 100,
      owner: 'Elena R.',
      closingDate: '10 Sep 2026',
      notes:
          'Contrato firmado por 1 año escolar. Primer servicio ejecutado exitosamente.',
      contractType: 'Recurrente Mensual',
      executionTime: 'Contrato 1 año',
      paymentTerms: 'Facturación mensual a 30 días',
      advancePercentage: 0,
      quoteItems: [
        QuoteItem(
          id: 'Q-105-1',
          category: 'Personal',
          concept:
              'Jardinero Especializado (Poda de formación, césped y cerco)',
          unitType: 'Operario',
          quantity: 2,
          unitPrice: 2200.0,
        ),
        QuoteItem(
          id: 'Q-105-2',
          category: 'Materiales',
          concept: 'Control Fitosanitario, Abono Orgánico y Fertilizantes',
          unitType: 'Servicio',
          quantity: 1,
          unitPrice: 1000.0,
        ),
      ],
    ),
    const OpportunityItem(
      id: 'OPP-106',
      title: 'Vigilancia Física & Control de Ronda Perimetral',
      clientName: 'Parque Industrial Sede Este',
      contactPerson: 'Lic. Gustavo Aguilera',
      phone: '72190877',
      serviceType: 'Seguridad',
      amount: 22000.0,
      stage: 'Calificación',
      probability: 40,
      owner: 'Carlos V.',
      closingDate: '05 Oct 2026',
      notes: 'Solicitaron cotización para 4 guardias con turnos rotativos 12h.',
      contractType: 'Recurrente Mensual',
      executionTime: 'Contrato 24 meses',
      paymentTerms: 'Facturación mensual',
      advancePercentage: 0,
      quoteItems: [
        QuoteItem(
          id: 'Q-106-1',
          category: 'Personal',
          concept: 'Puesto Guardia Seguridad Física 24h (Garitas 1 y 2)',
          unitType: 'Puesto 24/7',
          quantity: 3,
          unitPrice: 6800.0,
        ),
        QuoteItem(
          id: 'Q-106-2',
          category: 'Personal',
          concept: 'Patrullaje Preventivo Motorizado Nocturno (2 rondas/noche)',
          unitType: 'Servicio',
          quantity: 1,
          unitPrice: 1600.0,
        ),
      ],
    ),
    const OpportunityItem(
      id: 'OPP-107',
      title: 'Pulido, Sellado y Vitrificado de Pisos de Alto Tráfico',
      clientName: 'Banco Ganadero S.A.',
      contactPerson: 'Lic. Paola Mercado',
      phone: '77890123',
      serviceType: 'Limpieza',
      amount: 12500.0,
      stage: 'Propuesta',
      probability: 75,
      owner: 'Elena R.',
      closingDate: '28 Sep 2026',
      notes:
          'Trabajo puntual en fin de semana en sede central. Requiere 30% de anticipo para compra de químicos selladores.',
      contractType: 'Proyecto Único',
      executionTime: '5 días hábiles',
      paymentTerms: '30% Anticipo / 70% Entrega de Obra',
      advancePercentage: 30,
      quoteItems: [
        QuoteItem(
          id: 'Q-107-1',
          category: 'Personal',
          concept: 'Cuadrilla Especializada de Pulido Nocturno (6 operarios)',
          unitType: 'Servicio',
          quantity: 1,
          unitPrice: 6500.0,
        ),
        QuoteItem(
          id: 'Q-107-2',
          category: 'Materiales',
          concept:
              'Químicos Selladores y Cera Polimérica Antideslizante Alto Tráfico',
          unitType: 'Kit',
          quantity: 1,
          unitPrice: 3500.0,
        ),
        QuoteItem(
          id: 'Q-107-3',
          category: 'Equipamiento',
          concept:
              'Alquiler y Traslado Maquinaria Rotativa Industrial de Alta Velocidad',
          unitType: 'Servicio',
          quantity: 1,
          unitPrice: 2500.0,
        ),
      ],
    ),
  ];

  List<OpportunityItem> get _filteredDeals {
    return _deals.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesService =
          _selectedService == 'Todos' || item.serviceType == _selectedService;
      final matchesOwner =
          _selectedOwner == 'Todos' || item.owner == _selectedOwner;
      return matchesSearch && matchesService && matchesOwner;
    }).toList();
  }

  double get _totalPipelineAmount =>
      _filteredDeals.fold(0.0, (acc, item) => acc + item.amount);

  double get _weightedPipelineAmount => _filteredDeals.fold(
    0.0,
    (acc, item) => acc + (item.amount * (item.probability / 100)),
  );

  void _moveDeal(OpportunityItem deal, String newStage) {
    setState(() {
      final index = _deals.indexWhere((d) => d.id == deal.id);
      if (index != -1) {
        int newProb = deal.probability;
        if (newStage == 'Calificación') newProb = 30;
        if (newStage == 'Visita Técnica') newProb = 50;
        if (newStage == 'Propuesta') newProb = 70;
        if (newStage == 'Negociación') newProb = 85;
        if (newStage == 'Ganada') newProb = 100;

        _deals[index] = deal.copyWith(stage: newStage, probability: newProb);
      }
    });

    final isJustWon =
        newStage == 'Ganada' &&
        !CrmCustomersService().isOpportunityPromoted(deal.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Row(
          children: [
            const Icon(Icons.sync_alt, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${deal.id} movida a etapa "$newStage".',
                style: GoogleFonts.inter(fontSize: 12.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: isJustWon
            ? SnackBarAction(
                label: 'Ficha 360°',
                textColor: const Color(0xFF10B981),
                onPressed: () => _showPromoteToCustomerDialog(deal),
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _requestMoveDeal(OpportunityItem deal, String targetStage) {
    if (deal.stage == targetStage) return;

    if (targetStage == 'Visita Técnica') {
      if (deal.siteAddress.trim().isEmpty) {
        _showStageGateInspectionDialog(deal);
        return;
      }
    } else if (targetStage == 'Propuesta') {
      if (deal.quoteItems.isEmpty) {
        _showQuotationBuilderDialog(deal, targetStage: 'Propuesta');
        return;
      }
    } else if (targetStage == 'Negociación') {
      if (deal.taxId.trim().isEmpty || deal.legalBusinessName.trim().isEmpty) {
        _showStageGateLegalDialog(deal);
        return;
      }
    } else if (targetStage == 'Ganada') {
      _showStageGateWonDialog(deal);
      return;
    }

    _moveDeal(deal, targetStage);
  }

  void _advanceDeal(OpportunityItem deal) {
    final curIdx = _stages.indexOf(deal.stage);
    if (curIdx != -1 && curIdx < _stages.length - 1) {
      _requestMoveDeal(deal, _stages[curIdx + 1]);
    }
  }

  void _regressDeal(OpportunityItem deal) {
    final curIdx = _stages.indexOf(deal.stage);
    if (curIdx > 0) {
      _moveDeal(deal, _stages[curIdx - 1]);
    }
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'Calificación':
        return const Color(0xFF64748B);
      case 'Visita Técnica':
        return const Color(0xFF3B82F6);
      case 'Propuesta':
        return const Color(0xFFF59E0B);
      case 'Negociación':
        return const Color(0xFF8B5CF6);
      case 'Ganada':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getServiceColor(String service) {
    switch (service) {
      case 'Seguridad':
        return const Color(0xFF3B82F6);
      case 'Limpieza':
        return const Color(0xFF06B6D4);
      case 'Mantenimiento':
        return const Color(0xFFF59E0B);
      case 'Software':
        return const Color(0xFF8B5CF6);
      case 'Jardinería':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Seguridad':
        return Icons.shield_outlined;
      case 'Limpieza':
        return Icons.cleaning_services_outlined;
      case 'Mantenimiento':
        return Icons.build_outlined;
      case 'Software':
        return Icons.memory_outlined;
      case 'Jardinería':
        return Icons.yard_outlined;
      default:
        return Icons.business_outlined;
    }
  }

  Color _getContractTypeColor(String type) {
    switch (type) {
      case 'Proyecto Único':
        return const Color(0xFF8B5CF6);
      case 'Recurrente Mensual':
        return const Color(0xFF10B981);
      case 'Híbrido':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  IconData _getContractTypeIcon(String type) {
    switch (type) {
      case 'Proyecto Único':
        return Icons.construction_outlined;
      case 'Recurrente Mensual':
        return Icons.autorenew_outlined;
      case 'Híbrido':
        return Icons.layers_outlined;
      default:
        return Icons.work_outline;
    }
  }

  void _showNewDealDialog() {
    final titleCtrl = TextEditingController();
    final clientCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String serviceVal = 'Seguridad';
    String stageVal = 'Calificación';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_chart,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Nueva Oportunidad Comercial',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TÍTULO DEL NEGOCIO *',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: titleCtrl,
                    style: GoogleFonts.inter(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Ej. Vigilancia Perimetral 24h',
                      hintStyle: GoogleFonts.inter(fontSize: 12.5),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CLIENTE / EMPRESA *',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: clientCtrl,
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Empresa o Razón Social',
                                hintStyle: GoogleFonts.inter(fontSize: 12.5),
                                isDense: true,
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CONTACTO',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: contactCtrl,
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Persona clave',
                                hintStyle: GoogleFonts.inter(fontSize: 12.5),
                                isDense: true,
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MONTO ESTIMADO (BS.) *',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: amountCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.jetBrainsMono(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: GoogleFonts.inter(fontSize: 12.5),
                                isDense: true,
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TELÉFONO',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: phoneCtrl,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.jetBrainsMono(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: '77000000',
                                hintStyle: GoogleFonts.inter(fontSize: 12.5),
                                isDense: true,
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SERVICIO',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: serviceVal,
                              isExpanded: true,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                              items:
                                  [
                                        'Seguridad',
                                        'Limpieza',
                                        'Mantenimiento',
                                        'Software',
                                        'Jardinería',
                                      ]
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(
                                            s,
                                            style: GoogleFonts.inter(
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {
                                if (v != null) serviceVal = v;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ETAPA INICIAL',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: stageVal,
                              isExpanded: true,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                              items: _stages
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) stageVal = v;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'NOTAS / REQUERIMIENTOS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    style: GoogleFonts.inter(fontSize: 12.5),
                    decoration: InputDecoration(
                      hintText:
                          'Detalles técnicos, turnos, especificaciones...',
                      hintStyle: GoogleFonts.inter(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(10),
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
                style: GoogleFonts.inter(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (titleCtrl.text.isNotEmpty && clientCtrl.text.isNotEmpty) {
                  final parsedAmount =
                      double.tryParse(amountCtrl.text) ?? 8500.0;
                  final newDeal = OpportunityItem(
                    id: 'OPP-${_deals.length + 101}',
                    title: titleCtrl.text.trim(),
                    clientName: clientCtrl.text.trim(),
                    contactPerson: contactCtrl.text.trim().isEmpty
                        ? 'Contacto Comercial'
                        : contactCtrl.text.trim(),
                    phone: phoneCtrl.text.trim().isEmpty
                        ? '70000000'
                        : phoneCtrl.text.trim(),
                    serviceType: serviceVal,
                    amount: parsedAmount,
                    stage: stageVal,
                    probability: stageVal == 'Ganada' ? 100 : 40,
                    owner: 'Carlos V.',
                    closingDate: 'Fin de mes',
                    notes: notesCtrl.text.trim().isEmpty
                        ? 'Registrado desde el sistema comercial.'
                        : notesCtrl.text.trim(),
                    quoteItems: [
                      QuoteItem(
                        id: 'Q-${DateTime.now().millisecondsSinceEpoch}',
                        category: serviceVal,
                        concept: titleCtrl.text.trim(),
                        unitType: 'Servicio',
                        quantity: 1,
                        unitPrice: parsedAmount,
                      ),
                    ],
                  );

                  setState(() {
                    _deals.add(newDeal);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF065F46),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Oportunidad "${newDeal.title}" añadida con éxito.',
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Guardar Oportunidad',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDealDetailsDialog(OpportunityItem deal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stageCol = _getStageColor(deal.stage);
    final serviceCol = _getServiceColor(deal.serviceType);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: serviceCol.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getServiceIcon(deal.serviceType),
                  color: serviceCol,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.id,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      deal.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Estado actual, monto y modalidad de negocio
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deal.contractType == 'Proyecto Único'
                                      ? 'TOTAL PROYECTO / POR OBRA'
                                      : (deal.contractType ==
                                                'Recurrente Mensual'
                                            ? 'CANON MENSUAL RECURRENTE'
                                            : 'PRESUPUESTO COMBINADO'),
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  deal.contractType == 'Recurrente Mensual'
                                      ? 'Bs. ${deal.amount.toStringAsFixed(2)} / mes'
                                      : 'Bs. ${deal.amount.toStringAsFixed(2)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: stageCol.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: stageCol.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                deal.stage,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: stageCol,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: _getContractTypeColor(
                                  deal.contractType,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getContractTypeIcon(deal.contractType),
                                    size: 12,
                                    color: _getContractTypeColor(
                                      deal.contractType,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    deal.contractType,
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: _getContractTypeColor(
                                        deal.contractType,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${deal.executionTime} • ${deal.paymentTerms}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (deal.contractType == 'Proyecto Único' &&
                            deal.advancePercentage > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF3B82F6,
                                    ).withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Text(
                                  'Anticipo (${deal.advancePercentage}%): Bs. ${(deal.amount * deal.advancePercentage / 100).toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF3B82F6),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Text(
                                  'Contra Entrega: Bs. ${(deal.amount * (100 - deal.advancePercentage) / 100).toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (deal.contractType ==
                            'Recurrente Mensual') ...[
                          const SizedBox(height: 8),
                          Text(
                            'Valor Total Estimado (12 meses): Bs. ${(deal.amount * 12).toStringAsFixed(2)}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Desglose de cotización y servicios
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DESGLOSE DE PARTIDAS / COTIZACIÓN',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.3,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF3B82F6,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${deal.quoteItems.length} partidas',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (deal.quoteItems.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161F30)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        'Sin partidas detalladas aún. Presiona "Editar Cotización" para estructurar el presupuesto.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161F30)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        children: deal.quoteItems.map((item) {
                          final itemCatColor = _getServiceColor(item.category);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                  width: 0.8,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    color: itemCatColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.category.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: itemCatColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.concept,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity} ${item.unitType} × Bs. ${item.unitPrice.toStringAsFixed(0)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Bs. ${item.subtotal.toStringAsFixed(2)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Color(0xFF10B981)),
                          ),
                          icon: const Icon(
                            Icons.calculate_outlined,
                            size: 16,
                            color: Color(0xFF10B981),
                          ),
                          label: Text(
                            'Editar Cotización',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Future.microtask(() {
                              if (mounted) _showQuotationBuilderDialog(deal);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Color(0xFF3B82F6)),
                          ),
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                          label: Text(
                            'Ver Propuesta PDF',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Future.microtask(() {
                              if (mounted) _showProposalPreviewDialog(deal);
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Ficha del Cliente
                  Text(
                    'DETALLES DE LA CUENTA',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildDetailRow(
                    Icons.domain,
                    'Cliente:',
                    deal.clientName,
                    isDark,
                  ),
                  _buildDetailRow(
                    Icons.person,
                    'Contacto:',
                    deal.contactPerson,
                    isDark,
                  ),
                  _buildDetailRow(Icons.phone, 'Teléfono:', deal.phone, isDark),
                  _buildDetailRow(
                    Icons.person_pin,
                    'Asesor Comercial:',
                    deal.owner,
                    isDark,
                  ),
                  _buildDetailRow(
                    Icons.event,
                    'Fecha Estimada Cierre:',
                    deal.closingDate,
                    isDark,
                  ),

                  const SizedBox(height: 12),

                  // Probabilidad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROBABILIDAD ESTIMADA:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        '${deal.probability}%',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: deal.probability > 70
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: deal.probability / 100,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        deal.probability > 70
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Notas
                  Text(
                    'BITÁCORA / SEGUIMIENTO',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      deal.notes,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (deal.stage == 'Ganada') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF10B981),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'OPORTUNIDAD GANADA',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            CrmCustomersService().isOpportunityPromoted(deal.id)
                                ? 'Esta cuenta ya está registrada en el Directorio Clientes 360° con sus sedes operativas.'
                                : 'Promueve este negocio a la Ficha de Cliente 360° para formalizar su contrato y registrar su sede matriz.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (!CrmCustomersService().isOpportunityPromoted(
                            deal.id,
                          ))
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showPromoteToCustomerDialog(deal);
                              },
                              icon: const Icon(Icons.add_business, size: 16),
                              label: Text(
                                'Promover a Cliente 360°',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Cliente 360° Activo en Directorio',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Mover etapa
                  Text(
                    'ACCIONES DE ETAPA',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _stages.map((st) {
                      final isCurrent = st == deal.stage;
                      final stCol = _getStageColor(st);
                      return ActionChip(
                        avatar: isCurrent
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                        label: Text(st),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isCurrent
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCurrent
                              ? Colors.white
                              : (isDark
                                    ? Colors.white70
                                    : const Color(0xFF334155)),
                        ),
                        backgroundColor: isCurrent
                            ? stCol
                            : (isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _requestMoveDeal(deal, st);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // COMPUERTAS DE ETAPA (STAGE GATES DIALOGS)
  // ==========================================

  void _showStageGateInspectionDialog(OpportunityItem deal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();
    final siteNameCtrl = TextEditingController(
      text: deal.siteName.isNotEmpty
          ? deal.siteName
          : 'Sede Principal / ${deal.clientName}',
    );
    final siteAddressCtrl = TextEditingController(text: deal.siteAddress);
    final siteContactCtrl = TextEditingController(
      text: deal.siteContactName.isNotEmpty
          ? deal.siteContactName
          : deal.contactPerson,
    );
    final sitePhoneCtrl = TextEditingController(
      text: deal.siteContactPhone.isNotEmpty
          ? deal.siteContactPhone
          : deal.phone,
    );
    final siteAccessCtrl = TextEditingController(
      text: deal.siteAccessRequirements,
    );
    String selectedCity = deal.siteCity.isNotEmpty
        ? deal.siteCity
        : 'Santa Cruz';
    bool isHq = deal.isSiteHeadquarters;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF3B82F6),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Compuerta de Etapa: Visita Técnica',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ETAPA 2/5',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Registra la sede operativa donde se realizará la inspección física.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
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
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: siteNameCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Nombre de la Sede / Inmueble *',
                            hintText: 'Ej: Torre Corporativa Titanium - Sede Central',
                            prefixIcon: const Icon(Icons.business, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Ingresa el nombre de la sede'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: siteAddressCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Dirección Exacta de Inspección *',
                            hintText: 'Ej: Av. San Martín #450, Equipetrol Norte',
                            prefixIcon: const Icon(Icons.place_outlined, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'La dirección de la sede es obligatoria para la visita técnica'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedCity,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Ciudad',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Santa Cruz',
                                    child: Text('Santa Cruz'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'La Paz',
                                    child: Text('La Paz'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Cochabamba',
                                    child: Text('Cochabamba'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Tarija',
                                    child: Text('Tarija'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() => selectedCity = val);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: sitePhoneCtrl,
                                style: GoogleFonts.inter(fontSize: 12.5),
                                decoration: InputDecoration(
                                  labelText: 'Teléfono en Sitio',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: siteContactCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Persona que Recibe / Atiende la Visita',
                            hintText: 'Ej: Lic. Marcelo Justiniano (Administrador)',
                            prefixIcon: const Icon(Icons.person_outline, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: siteAccessCtrl,
                          maxLines: 2,
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Requisitos de Acceso & Restricciones',
                            hintText: 'Ej: Presentar cédula de identidad en garita, portar casco y chaleco reflectivo.',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            '¿Esta sede es la Casa Matriz del cliente?',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Se configurará como sede principal cuando se promueva a Clientes 360°.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          value: isHq,
                          activeThumbColor: const Color(0xFF3B82F6),
                          onChanged: (val) {
                            setDialogState(() => isHq = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final updatedDeal = deal.copyWith(
                        siteName: siteNameCtrl.text.trim(),
                        siteAddress: siteAddressCtrl.text.trim(),
                        siteCity: selectedCity,
                        siteContactName: siteContactCtrl.text.trim(),
                        siteContactPhone: sitePhoneCtrl.text.trim(),
                        siteAccessRequirements: siteAccessCtrl.text.trim(),
                        isSiteHeadquarters: isHq,
                      );
                      Navigator.pop(dCtx);
                      _moveDeal(updatedDeal, 'Visita Técnica');
                    }
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(
                    'Guardar Sede & Avanzar a Visita',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStageGateLegalDialog(OpportunityItem deal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();
    final legalNameCtrl = TextEditingController(
      text: deal.legalBusinessName.isNotEmpty
          ? deal.legalBusinessName
          : '${deal.clientName} S.R.L.',
    );
    final taxIdCtrl = TextEditingController(
      text: deal.taxId.isNotEmpty ? deal.taxId : '',
    );
    final repCtrl = TextEditingController(
      text: deal.legalRepresentative.isNotEmpty
          ? deal.legalRepresentative
          : deal.contactPerson,
    );
    final billingEmailCtrl = TextEditingController(
      text: deal.billingEmail.isNotEmpty
          ? deal.billingEmail
          : 'facturacion@${deal.clientName.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}.bo',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.gavel_outlined,
                      color: Color(0xFF8B5CF6),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Compuerta: Datos Fiscales & Minuta',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF8B5CF6,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ETAPA 4/5',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF8B5CF6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Completa la información jurídica para negociar la minuta y contrato.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: legalNameCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Razón Social Oficial (Facturación) *',
                            hintText: 'Ej: Corporación Inmobiliaria del Sur S.A.',
                            prefixIcon: const Icon(Icons.apartment, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'La razón social oficial es obligatoria'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: taxIdCtrl,
                          style: GoogleFonts.jetBrainsMono(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'NIT / Identificación Tributaria *',
                            hintText: 'Ej: 1029384756',
                            prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'El NIT es obligatorio para emitir la minuta'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: repCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Representante Legal / Apoderado',
                            hintText: 'Ej: Lic. Mariana Soto Mendoza (C.I. 4892102 SC)',
                            prefixIcon: const Icon(Icons.how_to_reg_outlined, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: billingEmailCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Correo de Facturación Electrónica *',
                            hintText: 'Ej: facturacion@titanium.bo',
                            prefixIcon: const Icon(Icons.email_outlined, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Ingresa el correo para envío de facturas'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final updatedDeal = deal.copyWith(
                        legalBusinessName: legalNameCtrl.text.trim(),
                        taxId: taxIdCtrl.text.trim(),
                        legalRepresentative: repCtrl.text.trim(),
                        billingEmail: billingEmailCtrl.text.trim(),
                      );
                      Navigator.pop(dCtx);
                      _moveDeal(updatedDeal, 'Negociación');
                    }
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(
                    'Guardar Datos Fiscales & Avanzar',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStageGateWonDialog(OpportunityItem deal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();
    final startDateCtrl = TextEditingController(
      text: deal.serviceStartDate.isNotEmpty
          ? deal.serviceStartDate
          : '01 Oct 2026',
    );
    final advancePaidCtrl = TextEditingController(
      text: deal.advancePaid > 0
          ? deal.advancePaid.toStringAsFixed(2)
          : (deal.amount * (deal.advancePercentage / 100)).toStringAsFixed(2),
    );
    final wonNotesCtrl = TextEditingController(
      text: deal.wonNotes.isNotEmpty
          ? deal.wonNotes
          : 'Contrato firmado conforme a propuesta técnica. Traspaso inmediato a Operaciones.',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.celebration_outlined,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Formalizar Cierre: Venta Ganada',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ETAPA FINAL',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Cierra la venta y transfiere automáticamente la cuenta a Clientes 360°.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
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
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Resumen consolidado de lo capturado en las etapas previas
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    deal.clientName,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      deal.contractType,
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Razón Social: ${deal.legalBusinessName.isNotEmpty ? deal.legalBusinessName : deal.clientName} • NIT: ${deal.taxId.isNotEmpty ? deal.taxId : "Pendiente"}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                'Sede Operativa: ${deal.siteAddress.isNotEmpty ? deal.siteAddress : "Sede Central"}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Monto Acordado: Bs. ${deal.amount.toStringAsFixed(2)} ${deal.contractType == "Recurrente Mensual" ? "/ mes" : "cerrado"}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: startDateCtrl,
                          style: GoogleFonts.inter(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Fecha de Inicio de Operaciones / Entrega *',
                            hintText: 'Ej: 01 Oct 2026',
                            prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Ingresa la fecha de inicio de operaciones'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: advancePaidCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.jetBrainsMono(fontSize: 12.5),
                          decoration: InputDecoration(
                            labelText: 'Anticipo / Garantía Recibida (Bs.)',
                            prefixIcon: const Icon(Icons.payments_outlined, size: 18),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: wonNotesCtrl,
                          maxLines: 2,
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Instrucciones para Despliegue Operativo',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final parsedAdvance =
                          double.tryParse(advancePaidCtrl.text.trim()) ?? 0.0;
                      final updatedDeal = deal.copyWith(
                        serviceStartDate: startDateCtrl.text.trim(),
                        advancePaid: parsedAdvance,
                        wonNotes: wonNotesCtrl.text.trim(),
                      );

                      // Promoción automática a Clientes 360° si no está registrado
                      if (!CrmCustomersService().isOpportunityPromoted(deal.id)) {
                        final initialBranch = CustomerBranch(
                          id: 'BR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                          name: deal.siteName.isNotEmpty
                              ? deal.siteName
                              : 'Sede Principal / ${deal.clientName}',
                          address: deal.siteAddress.isNotEmpty
                              ? deal.siteAddress
                              : 'Dirección coordinada en inspección',
                          localContact: deal.siteContactName.isNotEmpty
                              ? deal.siteContactName
                              : deal.contactPerson,
                          localPhone: deal.siteContactPhone.isNotEmpty
                              ? deal.siteContactPhone
                              : deal.phone,
                          isHeadquarters: deal.isSiteHeadquarters,
                          notes: deal.siteAccessRequirements,
                        );

                        final contract = CustomerContract(
                          id: 'CTR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                          title: deal.title,
                          contractType: deal.contractType,
                          serviceCategory: deal.serviceType,
                          totalAmount: deal.amount,
                          recurringMonthlyAmount:
                              deal.contractType == 'Recurrente Mensual'
                              ? deal.amount
                              : 0.0,
                          oneTimeAmount:
                              deal.contractType != 'Recurrente Mensual'
                              ? deal.amount
                              : 0.0,
                          paymentTerms: deal.paymentTerms,
                          executionTime: deal.executionTime,
                          advancePercentage: deal.advancePercentage,
                          status: 'Vigente',
                          startDate: startDateCtrl.text.trim(),
                          notes: wonNotesCtrl.text.trim(),
                        );

                        final customer = CustomerItem(
                          id: 'CLI-${DateTime.now().millisecondsSinceEpoch % 10000}',
                          legalName: deal.legalBusinessName.isNotEmpty
                              ? deal.legalBusinessName
                              : '${deal.clientName} S.R.L.',
                          tradeName: deal.clientName,
                          taxId: deal.taxId.isNotEmpty
                              ? deal.taxId
                              : '1029384756',
                          segment: deal.businessSegment,
                          status: 'Activo',
                          activeServices: [deal.serviceType],
                          contactPerson: deal.contactPerson,
                          phone: deal.phone,
                          email: deal.billingEmail.isNotEmpty
                              ? deal.billingEmail
                              : 'contacto@${deal.clientName.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}.bo',
                          opportunityId: deal.id,
                          startDate: startDateCtrl.text.trim(),
                          branches: [initialBranch],
                          contracts: [contract],
                          notes: wonNotesCtrl.text.trim(),
                        );

                        CrmCustomersService().addCustomer(customer);
                      }

                      Navigator.pop(dCtx);
                      _moveDeal(updatedDeal, 'Ganada');
                    }
                  },
                  icon: const Icon(Icons.verified, size: 18),
                  label: Text(
                    'Confirmar Cierre & Promover a 360°',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPromoteToCustomerDialog(OpportunityItem deal) {
    final formKey = GlobalKey<FormState>();
    final tradeNameCtrl = TextEditingController(text: deal.clientName);
    final legalNameCtrl = TextEditingController(
      text: '${deal.clientName} S.R.L.',
    );
    final taxIdCtrl = TextEditingController();
    final contactCtrl = TextEditingController(text: deal.contactPerson);
    final phoneCtrl = TextEditingController(text: deal.phone);
    final emailCtrl = TextEditingController(
      text:
          'contacto@${deal.clientName.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}.bo',
    );
    final billingCtrl = TextEditingController(
      text: deal.amount.toStringAsFixed(2),
    );

    final branchNameCtrl = TextEditingController(
      text: 'Sede Matriz / ${deal.clientName}',
    );
    final branchAddressCtrl = TextEditingController();
    final branchContactCtrl = TextEditingController(text: deal.contactPerson);
    final branchPhoneCtrl = TextEditingController(text: deal.phone);

    String segment = deal.clientName.toLowerCase().contains('condominio')
        ? 'Residencial B2C'
        : (deal.clientName.toLowerCase().contains('colegio')
              ? 'Sector Educativo'
              : 'Corporativo B2B');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final isDarkDialog = Theme.of(ctx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDarkDialog
                  ? const Color(0xFF0F172A)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_business,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promover a Cliente 360°',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDarkDialog
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Convertir oportunidad "${deal.id}" en ficha de cliente permanente.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 580,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. DATOS FISCALES DEL CLIENTE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3B82F6),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: tradeNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Comercial *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: taxIdCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'NIT / RUC *',
                                  hintText: 'Ej: 1029384756',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: legalNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Razón Social *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                initialValue: segment,
                                decoration: const InputDecoration(
                                  labelText: 'Segmento *',
                                  isDense: true,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Corporativo B2B',
                                    child: Text('Corporativo B2B'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Residencial B2C',
                                    child: Text('Residencial B2C'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sector Educativo',
                                    child: Text('Sector Educativo'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sector Público',
                                    child: Text('Sector Público'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => segment = v);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '2. CONTACTO Y FACTURACIÓN',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3B82F6),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: contactCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Contacto Principal *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: phoneCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Teléfono *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: emailCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Correo de Facturación *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: billingCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Canon Mensual (Bs.) *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || double.tryParse(v) == null)
                                    ? 'Inválido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '3. SEDE MATRIZ INICIAL (OBLIGATORIA)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3B82F6),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ubicación física inicial acordada durante el cierre de la negociación.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: branchNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Sede Matriz *',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: branchAddressCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Dirección Física *',
                                  hintText: 'Ej: Av. San Martín #230',
                                  isDense: true,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Requerido'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final newId =
                          'CLI-${DateTime.now().millisecondsSinceEpoch % 10000}';
                      final initialBranch = CustomerBranch(
                        id: 'BR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        name: branchNameCtrl.text.trim(),
                        address: branchAddressCtrl.text.trim(),
                        localContact: branchContactCtrl.text.trim().isNotEmpty
                            ? branchContactCtrl.text.trim()
                            : contactCtrl.text.trim(),
                        localPhone: branchPhoneCtrl.text.trim().isNotEmpty
                            ? branchPhoneCtrl.text.trim()
                            : phoneCtrl.text.trim(),
                        isHeadquarters: true,
                      );

                      final parsedAmount = double.parse(
                        billingCtrl.text.trim(),
                      );
                      final contract = CustomerContract(
                        id: 'CTR-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        title: deal.title,
                        contractType: deal.contractType,
                        serviceCategory: deal.serviceType,
                        totalAmount: parsedAmount,
                        recurringMonthlyAmount:
                            deal.contractType == 'Recurrente Mensual'
                            ? parsedAmount
                            : 0.0,
                        oneTimeAmount: deal.contractType != 'Recurrente Mensual'
                            ? parsedAmount
                            : 0.0,
                        paymentTerms: deal.paymentTerms,
                        executionTime: deal.executionTime,
                        advancePercentage: deal.advancePercentage,
                        status: 'Vigente',
                        startDate: 'Hoy',
                      );

                      final customer = CustomerItem(
                        id: newId,
                        legalName: legalNameCtrl.text.trim(),
                        tradeName: tradeNameCtrl.text.trim(),
                        taxId: taxIdCtrl.text.trim(),
                        segment: segment,
                        status: 'Activo',
                        activeServices: [deal.serviceType],
                        contactPerson: contactCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        opportunityId: deal.id,
                        startDate: 'Hoy',
                        branches: [initialBranch],
                        contracts: [contract],
                      );

                      CrmCustomersService().addCustomer(customer);
                      setState(() {});
                      Navigator.of(dCtx).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF0F172A),
                          content: Text(
                            '¡Oportunidad promovida! Cliente "${customer.tradeName}" añadido al Directorio 360° con su sede matriz.',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Confirmar & Promover a Cliente 360°'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQuotationBuilderDialog(OpportunityItem deal, {String? targetStage}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedContractType = deal.contractType;
    String executionTime = deal.executionTime;
    String paymentTerms = deal.paymentTerms;
    int advancePct = deal.advancePercentage > 0
        ? deal.advancePercentage
        : (deal.contractType == 'Proyecto Único' ? 50 : 0);
    List<QuoteItem> localItems = deal.quoteItems
        .map((q) => q.copyWith())
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            final double currentTotal = localItems.fold(
              0.0,
              (acc, item) => acc + item.subtotal,
            );
            final double subtotalNeto = currentTotal * 0.87;
            final double iva13 = currentTotal * 0.13;
            final double advanceAmount = currentTotal * (advancePct / 100);
            final double balanceAmount = currentTotal - advanceAmount;

            void addItem(QuoteItem newItem) {
              setModalState(() {
                localItems.add(newItem);
              });
            }

            void removeItem(int index) {
              setModalState(() {
                localItems.removeAt(index);
              });
            }

            void updateQuantity(int index, double delta) {
              setModalState(() {
                final current = localItems[index].quantity;
                final updated = (current + delta).clamp(1.0, 9999.0);
                localItems[index] = localItems[index].copyWith(
                  quantity: updated,
                );
              });
            }

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calculate,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cotizador & Presupuesto Comercial',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '${deal.id} • ${deal.clientName} (${deal.serviceType})',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: const Color(0xFF64748B),
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 880,
                  maxHeight: 720,
                ),
                child: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Selector de Modalidad de Negocio
                        Text(
                          'MODALIDAD DE CONTRATACIÓN',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildContractTypeTab(
                                  label: 'Proyecto Único / Obra',
                                  icon: Icons.construction_outlined,
                                  color: const Color(0xFF8B5CF6),
                                  isSelected:
                                      selectedContractType == 'Proyecto Único',
                                  isDark: isDark,
                                  onTap: () {
                                    setModalState(() {
                                      selectedContractType = 'Proyecto Único';
                                      advancePct = 50;
                                      executionTime = '7 días hábiles';
                                      paymentTerms =
                                          '50% Anticipo / 50% Recepción Conforme';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildContractTypeTab(
                                  label: 'Recurrente Mensual',
                                  icon: Icons.autorenew_outlined,
                                  color: const Color(0xFF10B981),
                                  isSelected:
                                      selectedContractType ==
                                      'Recurrente Mensual',
                                  isDark: isDark,
                                  onTap: () {
                                    setModalState(() {
                                      selectedContractType =
                                          'Recurrente Mensual';
                                      advancePct = 0;
                                      executionTime =
                                          'Contrato 12 meses renovable';
                                      paymentTerms =
                                          'Facturación mensual a 30 días';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildContractTypeTab(
                                  label: 'Modelo Híbrido',
                                  icon: Icons.layers_outlined,
                                  color: const Color(0xFFF59E0B),
                                  isSelected: selectedContractType == 'Híbrido',
                                  isDark: isDark,
                                  onTap: () {
                                    setModalState(() {
                                      selectedContractType = 'Híbrido';
                                      advancePct = 50;
                                      executionTime =
                                          '15 días instalación + Abono mensual';
                                      paymentTerms =
                                          'Hardware al contado / Monitoreo mensual';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 2. Parámetros Comerciales Dinámicos
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: selectedContractType == 'Proyecto Único'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'PLAZO DE EJECUCIÓN',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(
                                                    0xFF64748B,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              DropdownButtonFormField<String>(
                                                initialValue:
                                                    [
                                                      '3 días hábiles',
                                                      '7 días hábiles',
                                                      '15 días hábiles',
                                                      '30 días calendario',
                                                    ].contains(executionTime)
                                                    ? executionTime
                                                    : '7 días hábiles',
                                                isDense: true,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color(0xFF0F172A),
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                ),
                                                items:
                                                    [
                                                          '3 días hábiles',
                                                          '7 días hábiles',
                                                          '15 días hábiles',
                                                          '30 días calendario',
                                                        ]
                                                        .map(
                                                          (e) =>
                                                              DropdownMenuItem(
                                                                value: e,
                                                                child: Text(e),
                                                              ),
                                                        )
                                                        .toList(),
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    setModalState(
                                                      () => executionTime = val,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ESQUEMA DE COBRO (ANTICIPO %)',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(
                                                    0xFF64748B,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [30, 50, 70, 100].map((
                                                  pct,
                                                ) {
                                                  final isSel =
                                                      advancePct == pct;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 6,
                                                        ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          advancePct = pct;
                                                          paymentTerms =
                                                              pct == 100
                                                              ? '100% al Contado'
                                                              : '$pct% Anticipo / ${100 - pct}% Contra Entrega';
                                                        });
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 5,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isSel
                                                              ? const Color(
                                                                  0xFF8B5CF6,
                                                                )
                                                              : (isDark
                                                                    ? const Color(
                                                                        0xFF1E293B,
                                                                      )
                                                                    : const Color(
                                                                        0xFFE2E8F0,
                                                                      )),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          '$pct%',
                                                          style: GoogleFonts.inter(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: isSel
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF64748B,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF3B82F6,
                                            ).withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            'Anticipo Requerido ($advancePct%): Bs. ${advanceAmount.toStringAsFixed(2)}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF3B82F6),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF10B981,
                                            ).withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            'Saldo a la Entrega: Bs. ${balanceAmount.toStringAsFixed(2)}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF10B981),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : (selectedContractType == 'Recurrente Mensual'
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'VIGENCIA DEL CONTRATO',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                DropdownButtonFormField<String>(
                                                  initialValue:
                                                      [
                                                        '6 meses',
                                                        'Contrato 12 meses renovable',
                                                        'Contrato 24 meses',
                                                      ].contains(executionTime)
                                                      ? executionTime
                                                      : 'Contrato 12 meses renovable',
                                                  isDense: true,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: isDark
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF0F172A,
                                                          ),
                                                  ),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                  ),
                                                  items:
                                                      [
                                                            '6 meses',
                                                            'Contrato 12 meses renovable',
                                                            'Contrato 24 meses',
                                                          ]
                                                          .map(
                                                            (e) =>
                                                                DropdownMenuItem(
                                                                  value: e,
                                                                  child: Text(
                                                                    e,
                                                                  ),
                                                                ),
                                                          )
                                                          .toList(),
                                                  onChanged: (val) {
                                                    if (val != null) {
                                                      setModalState(
                                                        () =>
                                                            executionTime = val,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'CONDICIÓN DE FACTURACIÓN',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF10B981,
                                                    ).withValues(alpha: 0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Facturación mensual a 30 días calendario contra planilla',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xFF047857,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Esquema Híbrido: Incluye partida inicial de equipamiento/obra + servicio recurrente mensual de monitoreo y soporte.',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: const Color(0xFF64748B),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                        ),

                        const SizedBox(height: 14),

                        // 3. Encabezado de Partidas con Botón de Catálogo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DESGLOSE DE PARTIDAS (${localItems.length})',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.4,
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.add, size: 16),
                              label: Text(
                                'Añadir Partida / Catálogo',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () {
                                _showAddCatalogItemDialog(dialogContext, (
                                  newItem,
                                ) {
                                  addItem(newItem);
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // 4. Tabla Ejecutiva de Partidas
                        if (localItems.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF161F30)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No hay partidas registradas en esta cotización.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Haz clic en "Añadir Partida / Catálogo" para seleccionar servicios predefinidos.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 840,
                              child: Column(
                                children: [
                                  // Encabezado de la tabla
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFE2E8F0),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 25,
                                          child: Text(
                                            '#',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 95,
                                          child: Text(
                                            'RUBRO',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 215,
                                          child: Text(
                                            'CONCEPTO / DESCRIPCIÓN',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 85,
                                          child: Text(
                                            'UNIDAD',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            'CANTIDAD',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            'P. UNIT. (BS)',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'SUBTOTAL (BS)',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const SizedBox(width: 28),
                                      ],
                                    ),
                                  ),

                                  // Filas de la tabla
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(6),
                                      ),
                                    ),
                                    child: Column(
                                      children: List.generate(localItems.length, (
                                        idx,
                                      ) {
                                        final item = localItems[idx];
                                        final catColor = _getServiceColor(
                                          item.category,
                                        );

                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: idx % 2 == 0
                                                ? Colors.transparent
                                                : (isDark
                                                      ? const Color(0xFF131B2B)
                                                      : const Color(
                                                          0xFFF8FAFC,
                                                        )),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: isDark
                                                    ? const Color(0xFF1E293B)
                                                    : const Color(0xFFE2E8F0),
                                                width: 0.7,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // #
                                              SizedBox(
                                                width: 25,
                                                child: Text(
                                                  '${idx + 1}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Rubro
                                              SizedBox(
                                                width: 95,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: catColor.withValues(
                                                      alpha: 0.15,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    item.category.toUpperCase(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 8.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: catColor,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Concepto
                                              SizedBox(
                                                width: 215,
                                                child: TextFormField(
                                                  initialValue: item.concept,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDark
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF0F172A,
                                                          ),
                                                  ),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 4,
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: isDark
                                                            ? const Color(
                                                                0xFF334155,
                                                              )
                                                            : const Color(
                                                                0xFFCBD5E1,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    localItems[idx] = item
                                                        .copyWith(
                                                          concept:
                                                              val.trim().isEmpty
                                                              ? 'Servicio'
                                                              : val,
                                                        );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Unidad
                                              SizedBox(
                                                width: 85,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 3,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? const Color(
                                                            0xFF1E293B,
                                                          )
                                                        : const Color(
                                                            0xFFF1F5F9,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    item.unitType,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xFF64748B,
                                                      ),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Cantidad
                                              SizedBox(
                                                width: 90,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          updateQuantity(
                                                            idx,
                                                            -1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            3,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isDark
                                                              ? const Color(
                                                                  0xFF1E293B,
                                                                )
                                                              : const Color(
                                                                  0xFFE2E8F0,
                                                                ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                3,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.remove,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                          ),
                                                      child: Text(
                                                        item.quantity % 1 == 0
                                                            ? item.quantity
                                                                  .toInt()
                                                                  .toString()
                                                            : item.quantity
                                                                  .toString(),
                                                        style:
                                                            GoogleFonts.jetBrainsMono(
                                                              fontSize: 11.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          updateQuantity(
                                                            idx,
                                                            1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            3,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isDark
                                                              ? const Color(
                                                                  0xFF1E293B,
                                                                )
                                                              : const Color(
                                                                  0xFFE2E8F0,
                                                                ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                3,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.add,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // P. Unitario
                                              SizedBox(
                                                width: 90,
                                                child: TextFormField(
                                                  initialValue: item.unitPrice
                                                      .toStringAsFixed(0),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textAlign: TextAlign.right,
                                                  style:
                                                      GoogleFonts.jetBrainsMono(
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 4,
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    final parsed =
                                                        double.tryParse(val) ??
                                                        0.0;
                                                    setModalState(() {
                                                      localItems[idx] = item
                                                          .copyWith(
                                                            unitPrice: parsed,
                                                          );
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Subtotal
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  'Bs. ${item.subtotal.toStringAsFixed(2)}',
                                                  textAlign: TextAlign.right,
                                                  style:
                                                      GoogleFonts.jetBrainsMono(
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                          0xFF10B981,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Delete
                                              SizedBox(
                                                width: 28,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 16,
                                                    color: Color(0xFFEF4444),
                                                  ),
                                                  tooltip: 'Eliminar partida',
                                                  onPressed: () =>
                                                      removeItem(idx),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 14),

                        // 5. Liquidación Financiera
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161F30)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal Operativo Neto:',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'Bs. ${subtotalNeto.toStringAsFixed(2)}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'IVA (13% Ley 843 Facturado):',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'Bs. ${iva13.toStringAsFixed(2)}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedContractType == 'Proyecto Único'
                                            ? 'TOTAL PROYECTO / POR OBRA'
                                            : (selectedContractType ==
                                                      'Recurrente Mensual'
                                                  ? 'CANON MENSUAL RECURRENTE'
                                                  : 'PRESUPUESTO COMBINADO'),
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                      Text(
                                        selectedContractType == 'Proyecto Único'
                                            ? 'Anticipo ($advancePct%): Bs. ${advanceAmount.toStringAsFixed(2)} | Saldo Entrega: Bs. ${balanceAmount.toStringAsFixed(2)}'
                                            : (selectedContractType ==
                                                      'Recurrente Mensual'
                                                  ? 'Proyección anual (12 meses): Bs. ${(currentTotal * 12).toStringAsFixed(2)}'
                                                  : 'Equipamiento inicial + abono de servicio mensual'),
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    selectedContractType == 'Recurrente Mensual'
                                        ? 'Bs. ${currentTotal.toStringAsFixed(2)} / mes'
                                        : 'Bs. ${currentTotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Color(0xFF3B82F6)),
                  ),
                  icon: const Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 16,
                    color: Color(0xFF3B82F6),
                  ),
                  label: Text(
                    'Ver Propuesta PDF',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  onPressed: () {
                    final previewDeal = deal.copyWith(
                      contractType: selectedContractType,
                      executionTime: executionTime,
                      paymentTerms: paymentTerms,
                      advancePercentage: advancePct,
                      quoteItems: localItems,
                      amount: currentTotal,
                    );
                    Navigator.pop(ctx);
                    _showProposalPreviewDialog(previewDeal);
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(
                    'Guardar Cotización',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () {
                    final idx = _deals.indexWhere((d) => d.id == deal.id);
                    OpportunityItem? updatedDeal;
                    if (idx != -1) {
                      updatedDeal = deal.copyWith(
                        contractType: selectedContractType,
                        executionTime: executionTime,
                        paymentTerms: paymentTerms,
                        advancePercentage: advancePct,
                        quoteItems: localItems,
                        amount: currentTotal,
                      );
                      setState(() {
                        _deals[idx] = updatedDeal!;
                      });
                    }
                    Navigator.pop(ctx);
                    if (targetStage != null && updatedDeal != null) {
                      _moveDeal(updatedDeal, targetStage);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF065F46),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Cotización ($selectedContractType) de "${deal.title}" actualizada: Bs. ${currentTotal.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildContractTypeTab({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF475569)),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCatalogItemDialog(
    BuildContext parentCtx,
    Function(QuoteItem) onAdd,
  ) {
    final isDark = Theme.of(parentCtx).brightness == Brightness.dark;
    final conceptCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'Servicio');
    final priceCtrl = TextEditingController(text: '1500');
    String catVal = 'Personal';

    final catalogPresets = [
      // Seguridad
      const QuoteItem(
        id: '',
        category: 'Personal',
        concept: 'Puesto Vigilancia Física 24/7 (3 guardias rotativos)',
        unitType: 'Puesto 24/7',
        quantity: 1,
        unitPrice: 6800.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Personal',
        concept: 'Guardia Seguridad Turno Diurno 12h',
        unitType: 'Puesto 12h',
        quantity: 1,
        unitPrice: 3800.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Personal',
        concept: 'Patrullaje Preventivo Motorizado Nocturno',
        unitType: 'Servicio',
        quantity: 1,
        unitPrice: 1600.0,
      ),
      // Limpieza
      const QuoteItem(
        id: '',
        category: 'Limpieza',
        concept: 'Operario Limpieza Diaria Oficinas y Áreas Comunes',
        unitType: 'Operario',
        quantity: 1,
        unitPrice: 3500.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Limpieza',
        concept: 'Limpieza Profunda Post-Construcción / Entrega de Obra',
        unitType: 'm²',
        quantity: 200,
        unitPrice: 25.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Limpieza',
        concept: 'Lavado y Desinfección Profunda de Tanques de Agua Potable',
        unitType: 'Tanque',
        quantity: 2,
        unitPrice: 1800.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Limpieza',
        concept: 'Pulido, Sellado y Vitrificado de Pisos de Alto Tráfico',
        unitType: 'm²',
        quantity: 100,
        unitPrice: 35.0,
      ),
      // Mantenimiento
      const QuoteItem(
        id: '',
        category: 'Mantenimiento',
        concept: 'Mantenimiento Preventivo y Calibración Grupo Electrógeno',
        unitType: 'Global',
        quantity: 1,
        unitPrice: 4200.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Mantenimiento',
        concept: 'Inspección y Reparación Bombas Hidroneumáticas',
        unitType: 'Servicio',
        quantity: 1,
        unitPrice: 2000.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Materiales',
        concept: 'Jardinero Especializado (Poda, abono y riego)',
        unitType: 'Operario',
        quantity: 1,
        unitPrice: 2200.0,
      ),
      // Equipamiento y Tecnología
      const QuoteItem(
        id: '',
        category: 'Equipamiento',
        concept: 'Kit Radios VHF Motorola + Base y Cargador',
        unitType: 'Kit',
        quantity: 1,
        unitPrice: 500.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Tecnología',
        concept: 'Cámara IP Dahua 4K IA Reconocimiento Facial y LPR',
        unitType: 'Unid.',
        quantity: 4,
        unitPrice: 2500.0,
      ),
      const QuoteItem(
        id: '',
        category: 'Tecnología',
        concept: 'Rondín Electrónico RFID con Reportes en Tiempo Real',
        unitType: 'Servicio',
        quantity: 1,
        unitPrice: 400.0,
      ),
    ];

    showDialog(
      context: parentCtx,
      builder: (catDialogCtx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Catálogo de Partidas y Servicios',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540, maxHeight: 500),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECCIONA DEL CATÁLOGO DE SERVICIOS',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...catalogPresets.map((preset) {
                    final pColor = _getServiceColor(preset.category);
                    return InkWell(
                      onTap: () {
                        onAdd(
                          preset.copyWith(
                            id: 'Q-${DateTime.now().millisecondsSinceEpoch}',
                          ),
                        );
                        Navigator.pop(catDialogCtx);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: pColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                preset.category.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: pColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preset.concept,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Unidad: ${preset.unitType} • Base: Bs. ${preset.unitPrice.toStringAsFixed(0)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                              color: Color(0xFF3B82F6),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Text(
                    'O CREA UNA PARTIDA PERSONALIZADA',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: conceptCtrl,
                    style: GoogleFonts.inter(fontSize: 12),
                    decoration: InputDecoration(
                      labelText: 'Descripción / Concepto',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: unitCtrl,
                          style: GoogleFonts.inter(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Unidad (m², Puesto, Kit...)',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.jetBrainsMono(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Precio Unit. (Bs.)',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        'Agregar Partida Personalizada',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        if (conceptCtrl.text.isNotEmpty) {
                          onAdd(
                            QuoteItem(
                              id: 'Q-${DateTime.now().millisecondsSinceEpoch}',
                              category: catVal,
                              concept: conceptCtrl.text.trim(),
                              unitType: unitCtrl.text.trim().isEmpty
                                  ? 'Servicio'
                                  : unitCtrl.text.trim(),
                              quantity: 1,
                              unitPrice:
                                  double.tryParse(priceCtrl.text) ?? 1000.0,
                            ),
                          );
                          Navigator.pop(catDialogCtx);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(catDialogCtx),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(color: const Color(0xFF64748B)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showProposalPreviewDialog(OpportunityItem deal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtotal = deal.amount * 0.87;
    final iva = deal.amount * 0.13;
    final advanceAmount = deal.amount * (deal.advancePercentage / 100);
    final balanceAmount = deal.amount - advanceAmount;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF3B82F6),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.contractType == 'Proyecto Único'
                          ? 'Propuesta Técnico-Económica (Por Obra)'
                          : (deal.contractType == 'Recurrente Mensual'
                                ? 'Propuesta Comercial (Servicio Continuo)'
                                : 'Propuesta Integral (Hardware + Servicio)'),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'CÓDIGO OFICIAL: PROP-2026-${deal.id}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680, maxHeight: 600),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Membrete simulado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ELITE MULTISERVICIOS S.R.L.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                            Text(
                              'Santa Cruz - Bolivia',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Dirigido a: ${deal.clientName}',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Atención: ${deal.contactPerson} • Cel: ${deal.phone}',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          'Modalidad: ${deal.contractType} | Plazo: ${deal.executionTime} | Validez: 15 días calendario',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tabla de Cotización
                  Text(
                    'RESUMEN ECONÓMICO Y ALCANCE DE PARTIDAS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Header tabla
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'PARTIDA / CONCEPTO',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'UNIDAD / CANT.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'P. UNIT.',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'TOTAL (BS)',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Items tabla
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(6),
                      ),
                    ),
                    child: Column(
                      children: deal.quoteItems.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.concept,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    Text(
                                      item.category,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity} ${item.unitType}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(fontSize: 11),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Bs. ${item.unitPrice.toStringAsFixed(0)}',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Bs. ${item.subtotal.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Liquidación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 320,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161F30)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal Operativo:',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  'Bs. ${subtotal.toStringAsFixed(2)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'IVA (13% Ley 843):',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  'Bs. ${iva.toStringAsFixed(2)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  deal.contractType == 'Recurrente Mensual'
                                      ? 'TOTAL FACTURADO / MES:'
                                      : 'TOTAL FACTURADO:',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  deal.contractType == 'Recurrente Mensual'
                                      ? 'Bs. ${deal.amount.toStringAsFixed(2)} / mes'
                                      : 'Bs. ${deal.amount.toStringAsFixed(2)}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            if (deal.contractType == 'Proyecto Único' &&
                                deal.advancePercentage > 0) ...[
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Anticipo Requerido (${deal.advancePercentage}%):',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: const Color(0xFF3B82F6),
                                    ),
                                  ),
                                  Text(
                                    'Bs. ${advanceAmount.toStringAsFixed(2)}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF3B82F6),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Saldo Contra Entrega:',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                  Text(
                                    'Bs. ${balanceAmount.toStringAsFixed(2)}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Condiciones
                  Text(
                    'CONDICIONES CONTRACTUALES & GARANTÍAS',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161F30)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Plazo de Ejecución / Vigencia: ${deal.executionTime}.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '• Condiciones de Cobro: ${deal.paymentTerms}.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '• Personal asegurado con seguro laboral, uniforme institucional y credenciales.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '• Centro de Control Operativo disponible para supervisión y atención de contingencias 24/7.',
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
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          actions: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
              ),
              icon: const Icon(Icons.share, size: 16, color: Color(0xFF10B981)),
              label: Text(
                'Enviar por WhatsApp',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF0F172A),
                    content: Text(
                      'Enlace de la Propuesta enviado al contacto ${deal.phone}.',
                    ),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
              ),
              icon: const Icon(Icons.download, size: 16),
              label: Text(
                'Descargar PDF',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF1E3A8A),
                    content: Text(
                      'Descargando archivo: PROP-2026-${deal.id}.pdf',
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cerrar',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredDeals;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        final hPad = isMobile ? 12.0 : 24.0;
        final vPad = isMobile ? 14.0 : 24.0;

        // 1. Header adaptativo
        final titleSection = Column(
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
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PIPELINE COMERCIAL',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B82F6),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Text(
                  'Fase 1: Negociación & Cierres',
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
              'Embudo de Ventas & Oportunidades',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 19 : 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gestión de cotizaciones, visitas técnicas, probabilidades y contratos.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        );

        final newDealButton = ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
          ),
          onPressed: _showNewDealDialog,
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Nueva Oportunidad',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleSection,
                    const SizedBox(height: 12),
                    newDealButton,
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: titleSection),
                    const SizedBox(width: 16),
                    newDealButton,
                  ],
                ),

              const SizedBox(height: 18),

              // 2. Barra de KPIs Ejecutivos
              LayoutBuilder(
                builder: (context, kpiBox) {
                  final isKpiWide = kpiBox.maxWidth > 900;
                  final isKpiTablet = kpiBox.maxWidth > 520;

                  final cardTotal = _buildKpiCard(
                    title: 'VALOR TOTAL DEL PIPELINE',
                    value: 'Bs. ${_totalPipelineAmount.toStringAsFixed(2)}',
                    subtitle:
                        '${_filteredDeals.length} oportunidades registradas',
                    color: const Color(0xFF3B82F6),
                    icon: Icons.account_balance_wallet_outlined,
                    isDark: isDark,
                  );

                  final cardWeighted = _buildKpiCard(
                    title: 'VALOR PONDERADO (PROB)',
                    value: 'Bs. ${_weightedPipelineAmount.toStringAsFixed(2)}',
                    subtitle: 'Ingreso estimado por probabilidad',
                    color: const Color(0xFF6366F1),
                    icon: Icons.auto_graph_outlined,
                    isDark: isDark,
                  );

                  final cardActive = _buildKpiCard(
                    title: 'EN NEGOCIACIÓN ACTIVA',
                    value:
                        '${_filteredDeals.where((d) => d.stage != 'Ganada').length}',
                    subtitle: 'Pendientes de cierre',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.pending_actions_outlined,
                    isDark: isDark,
                  );

                  final cardWon = _buildKpiCard(
                    title: 'CERRADAS GANADAS',
                    value:
                        '${_filteredDeals.where((d) => d.stage == 'Ganada').length}',
                    subtitle: 'Contratos asegurados',
                    color: const Color(0xFF10B981),
                    icon: Icons.verified_outlined,
                    isDark: isDark,
                  );

                  if (isKpiWide) {
                    return Row(
                      children: [
                        Expanded(child: cardTotal),
                        const SizedBox(width: 12),
                        Expanded(child: cardWeighted),
                        const SizedBox(width: 12),
                        Expanded(child: cardActive),
                        const SizedBox(width: 12),
                        Expanded(child: cardWon),
                      ],
                    );
                  } else if (isKpiTablet) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: cardTotal),
                            const SizedBox(width: 12),
                            Expanded(child: cardWeighted),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: cardActive),
                            const SizedBox(width: 12),
                            Expanded(child: cardWon),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        cardTotal,
                        const SizedBox(height: 10),
                        cardWeighted,
                        const SizedBox(height: 10),
                        cardActive,
                        const SizedBox(height: 10),
                        cardWon,
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 18),

              // 3. Barra de Búsqueda y Filtros
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
                  builder: (context, filterBox) {
                    final isFilterWide = filterBox.maxWidth > 800;

                    final searchInput = TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: GoogleFonts.inter(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Buscar oportunidad o cliente...',
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

                    final serviceDropdown = Container(
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
                          value: _selectedService,
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
                          items:
                              [
                                    'Todos',
                                    'Seguridad',
                                    'Limpieza',
                                    'Mantenimiento',
                                    'Software',
                                    'Jardinería',
                                  ]
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s == 'Todos' ? 'Servicio: Todos' : s,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedService = v);
                          },
                        ),
                      ),
                    );

                    final ownerDropdown = Container(
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
                          value: _selectedOwner,
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
                          items:
                              ['Todos', 'Carlos V.', 'Elena R.', 'Rogelio A.']
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s == 'Todos' ? 'Asesor: Todos' : s,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedOwner = v);
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
                              Icons.view_kanban_outlined,
                              size: 18,
                              color: !_isListView
                                  ? const Color(0xFF3B82F6)
                                  : (isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8)),
                            ),
                            tooltip: 'Tablero Kanban',
                            onPressed: () =>
                                setState(() => _isListView = false),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.format_list_bulleted_rounded,
                              size: 18,
                              color: _isListView
                                  ? const Color(0xFF3B82F6)
                                  : (isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8)),
                            ),
                            tooltip: 'Vista de Lista',
                            onPressed: () => setState(() => _isListView = true),
                          ),
                        ],
                      ),
                    );

                    if (isFilterWide) {
                      return Row(
                        children: [
                          Expanded(child: searchInput),
                          const SizedBox(width: 12),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: serviceDropdown,
                          ),
                          const SizedBox(width: 12),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: ownerDropdown,
                          ),
                          const SizedBox(width: 12),
                          viewToggle,
                        ],
                      );
                    } else if (filterBox.maxWidth > 560) {
                      return Column(
                        children: [
                          searchInput,
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: serviceDropdown),
                              const SizedBox(width: 8),
                              Expanded(child: ownerDropdown),
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
                          searchInput,
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: serviceDropdown),
                              const SizedBox(width: 8),
                              Expanded(child: ownerDropdown),
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

              const SizedBox(height: 18),

              // 4. Contenido Principal: Modo Móvil con Selector de Etapas o Kanban Desktop
              if (_isListView)
                _buildListView(filtered, isDark)
              else if (isMobile)
                _buildMobileStageView(filtered, isDark)
              else
                _buildDesktopKanban(filtered, isDark),
            ],
          ),
        );
      },
    );
  }

  // Selector de etapas y lista vertical fluida para Móviles (< 800px)
  Widget _buildMobileStageView(List<OpportunityItem> filtered, bool isDark) {
    final stageDeals = filtered
        .where((d) => d.stage == _activeMobileStage)
        .toList();
    final stageAmount = stageDeals.fold(0.0, (acc, item) => acc + item.amount);
    final stageColor = _getStageColor(_activeMobileStage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pestañas / Chips de Etapas Horizontales
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _stages.map((st) {
              final isSelected = _activeMobileStage == st;
              final count = filtered.where((d) => d.stage == st).length;
              final col = _getStageColor(st);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: col,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(st),
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
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B)),
                  ),
                  selectedColor: col,
                  backgroundColor: isDark
                      ? const Color(0xFF0F172A)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? col
                          : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  onSelected: (sel) {
                    if (sel) setState(() => _activeMobileStage = st);
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Barra informativa de la etapa activa
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: stageColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Etapa: $_activeMobileStage',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                'Subtotal: Bs. ${stageAmount.toStringAsFixed(2)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Lista de tarjetas en esta etapa
        if (stageDeals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36),
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
                  Icons.inbox_outlined,
                  size: 36,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(height: 8),
                Text(
                  'No hay oportunidades en la etapa "$_activeMobileStage"',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stageDeals.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              return _buildDealCard(stageDeals[idx], isDark);
            },
          ),
      ],
    );
  }

  // Tablero Kanban Multi-Columna (Desktop >= 800px)
  Widget _buildDesktopKanban(List<OpportunityItem> filtered, bool isDark) {
    return SizedBox(
      height: 640,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _stages.length,
        separatorBuilder: (_, index) => const SizedBox(width: 14),
        itemBuilder: (context, stageIndex) {
          final stage = _stages[stageIndex];
          final stageDeals = filtered.where((d) => d.stage == stage).toList();
          final stageAmount = stageDeals.fold(
            0.0,
            (acc, item) => acc + item.amount,
          );
          final stageCol = _getStageColor(stage);

          return Container(
            width: 310,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                // Cabecera de la columna Kanban
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: stageCol,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            stage,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${stageDeals.length}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sub-total de la columna
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        'Bs. ${stageAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de tarjetas en esta columna
                Expanded(
                  child: stageDeals.isEmpty
                      ? Center(
                          child: Text(
                            'Sin oportunidades',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          itemCount: stageDeals.length,
                          separatorBuilder: (_, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, cardIdx) {
                            return _buildDealCard(stageDeals[cardIdx], isDark);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Vista de Lista Consolidada
  Widget _buildListView(List<OpportunityItem> filtered, bool isDark) {
    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 36, color: Color(0xFF64748B)),
            const SizedBox(height: 8),
            Text(
              'No se encontraron oportunidades con los filtros seleccionados.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, index) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        return _buildDealCard(filtered[idx], isDark);
      },
    );
  }

  // Tarjeta Individual de Oportunidad (Kanban Card)
  Widget _buildDealCard(OpportunityItem deal, bool isDark) {
    final serviceCol = _getServiceColor(deal.serviceType);
    final stageCol = _getStageColor(deal.stage);
    final curStageIdx = _stages.indexOf(deal.stage);

    return InkWell(
      onTap: () => _showDealDetailsDialog(deal),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera de la tarjeta: Rubro y Menú
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: serviceCol.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getServiceIcon(deal.serviceType),
                              size: 12,
                              color: serviceCol,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              deal.serviceType,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: serviceCol,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getContractTypeColor(
                            deal.contractType,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getContractTypeIcon(deal.contractType),
                              size: 10,
                              color: _getContractTypeColor(deal.contractType),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              deal.contractType == 'Recurrente Mensual'
                                  ? 'Mensual'
                                  : (deal.contractType == 'Proyecto Único'
                                        ? 'Obra Única'
                                        : 'Híbrido'),
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: _getContractTypeColor(deal.contractType),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        deal.id,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  tooltip: 'Opciones de oportunidad',
                  onSelected: (action) {
                    if (action == 'quote') {
                      _showQuotationBuilderDialog(deal);
                    } else if (action == 'proposal') {
                      _showProposalPreviewDialog(deal);
                    } else if (action.startsWith('move:')) {
                      final targetStage = action.replaceFirst('move:', '');
                      _requestMoveDeal(deal, targetStage);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'quote',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calculate_outlined,
                            size: 16,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Editar Cotización',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'proposal',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ver Propuesta Formal',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    ..._stages
                        .where((s) => s != deal.stage)
                        .map(
                          (s) => PopupMenuItem(
                            value: 'move:$s',
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: _getStageColor(s),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Mover a: $s',
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Título de la oportunidad
            Text(
              deal.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 3),

            // Cliente y Contacto
            Row(
              children: [
                const Icon(Icons.business, size: 12, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    deal.clientName,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Barra de probabilidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Probabilidad:',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                Text(
                  '${deal.probability}%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: stageCol,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: deal.probability / 100,
                minHeight: 4,
                backgroundColor: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(stageCol),
              ),
            ),

            const SizedBox(height: 10),

            // Pie: Monto, Asesor y Botones Rápidos de Etapa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Bs. ${deal.amount.toStringAsFixed(2)}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          deal.contractType == 'Recurrente Mensual'
                              ? '/mes'
                              : (deal.contractType == 'Híbrido'
                                    ? '/mes+obra'
                                    : '(Obra)'),
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_pin,
                          size: 11,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          deal.owner,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calculate_outlined, size: 16),
                      tooltip: 'Armar / Editar Cotización',
                      visualDensity: VisualDensity.compact,
                      color: const Color(0xFF10B981),
                      onPressed: () => _showQuotationBuilderDialog(deal),
                    ),
                    if (curStageIdx > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 14),
                        tooltip: 'Retroceder etapa',
                        visualDensity: VisualDensity.compact,
                        color: const Color(0xFF64748B),
                        onPressed: () => _regressDeal(deal),
                      ),
                    if (curStageIdx < _stages.length - 1)
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 14),
                        tooltip: 'Avanzar a ${_stages[curStageIdx + 1]}',
                        visualDensity: VisualDensity.compact,
                        color: const Color(0xFF3B82F6),
                        onPressed: () => _advanceDeal(deal),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de KPI
  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
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
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
