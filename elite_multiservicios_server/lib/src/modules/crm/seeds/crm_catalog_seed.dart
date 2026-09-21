import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../repositories/crm_catalog_repository.dart';

/// Seed de base de datos para inicializar el catálogo de Rubros, Líneas de Servicio
/// y Partidas con tarifas de referencia de Elite Multiservicios.
class CrmCatalogSeed {
  static Future<void> seed(Session session) async {
    session.log(
      'Ejecutando seed de Catálogo y Tarifario en PostgreSQL...',
      level: LogLevel.info,
    );

    final repo = CrmCatalogRepository(session);

    // =========================================================================
    // 1. SECTORES / RUBROS
    // =========================================================================
    final sectorsData = [
      {
        'code': 'SEC-SALUD',
        'name': 'Clínicas y centros médicos',
        'desc': 'Sector hospitalario, clínicas privadas y laboratorios',
      },
      {
        'code': 'SEC-CORP',
        'name': 'Corporativo / Oficinas',
        'desc': 'Edificios empresariales y oficinas administrativas',
      },
      {
        'code': 'SEC-EDU',
        'name': 'Colegios & Educación',
        'desc': 'Unidades educativas, colegios y campus universitarios',
      },
      {
        'code': 'SEC-BANCA',
        'name': 'Banca & Finanzas',
        'desc': 'Sucursales bancarias y entidades financieras',
      },
      {
        'code': 'SEC-IND',
        'name': 'Industria & Bodegas',
        'desc': 'Parques industriales, centros logísticos y almacenes',
      },
      {
        'code': 'SEC-COND',
        'name': 'Condominios & Edificios Residenciales',
        'desc': 'Condominios cerrados y torres de departamentos',
      },
    ];

    final Map<String, int> sectorIdByCode = {};
    for (final s in sectorsData) {
      final existing = await CrmSector.db.findFirstRow(
        session,
        where: (t) => t.code.equals(s['code']!),
      );
      if (existing != null) {
        sectorIdByCode[s['code']!] = existing.id!;
      } else {
        final inserted = await repo.createSector(
          CrmSector(
            code: s['code']!,
            name: s['name']!,
            description: s['desc'],
            isActive: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        sectorIdByCode[s['code']!] = inserted.id!;
      }
    }

    // =========================================================================
    // 2. LÍNEAS DE SERVICIO
    // =========================================================================
    final serviceLinesData = [
      {
        'code': 'SRV-LIMP-HOSP',
        'name': 'Limpieza Hospitalaria & Bioseguridad',
        'cat': 'Limpieza',
      },
      {
        'code': 'SRV-MANT-CORP',
        'name': 'Mantenimiento Corporativo',
        'cat': 'Mantenimiento',
      },
      {
        'code': 'SRV-MANT-JARD',
        'name': 'Mantenimiento & Jardinería Educativa',
        'cat': 'Mantenimiento',
      },
      {
        'code': 'SRV-SEG-VIG',
        'name': 'Seguridad & Vigilancia Física',
        'cat': 'Personal',
      },
      {
        'code': 'SRV-DES-FUM',
        'name': 'Desinfección & Fumigación Integral',
        'cat': 'Limpieza',
      },
      {
        'code': 'SRV-EQ-RAD',
        'name': 'Equipamiento de Comunicaciones',
        'cat': 'Equipamiento',
      },
      {
        'code': 'SRV-TEC-CAM',
        'name': 'CCTV y Seguridad Electrónica',
        'cat': 'Tecnología',
      },
    ];

    final Map<String, int> lineIdByCode = {};
    for (final l in serviceLinesData) {
      final existing = await CrmServiceLine.db.findFirstRow(
        session,
        where: (t) => t.code.equals(l['code']!),
      );
      if (existing != null) {
        lineIdByCode[l['code']!] = existing.id!;
      } else {
        final inserted = await repo.createServiceLine(
          CrmServiceLine(
            code: l['code']!,
            name: l['name']!,
            category: l['cat']!,
            description: 'Línea de servicio especializada en ${l['name']}',
            isActive: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        lineIdByCode[l['code']!] = inserted.id!;
      }
    }

    // =========================================================================
    // 3. PARTIDAS DEL CATÁLOGO Y TARIFARIO MAESTRO
    // =========================================================================
    final catalogData = [
      {
        'code': 'CAT-VIG-247',
        'lineCode': 'SRV-SEG-VIG',
        'cat': 'Personal',
        'concept': 'Puesto Vigilancia Física 24/7 (3 guardias rotativos)',
        'calc': 'PER_POSITION',
        'unit': 'Puesto 24/7',
        'price': 6800.0,
        'minQty': 1.0,
        'meta': jsonEncode({
          'hoursPerShift': 12,
          'daysPerMonth': 26,
          'guardsPerPosition': 3,
        }),
      },
      {
        'code': 'CAT-VIG-12H',
        'lineCode': 'SRV-SEG-VIG',
        'cat': 'Personal',
        'concept': 'Guardia Seguridad Turno Diurno 12h',
        'calc': 'PER_POSITION',
        'unit': 'Puesto 12h',
        'price': 3800.0,
        'minQty': 1.0,
        'meta': jsonEncode({
          'hoursPerShift': 12,
          'daysPerMonth': 26,
          'guardsPerPosition': 1,
        }),
      },
      {
        'code': 'CAT-PAT-MOT',
        'lineCode': 'SRV-SEG-VIG',
        'cat': 'Personal',
        'concept': 'Patrullaje Preventivo Motorizado Nocturno',
        'calc': 'PER_UNIT',
        'unit': 'Servicio',
        'price': 1600.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-LIMP-OFI',
        'lineCode': 'SRV-LIMP-HOSP',
        'cat': 'Limpieza',
        'concept': 'Operario Limpieza Diaria Oficinas y Áreas Comunes',
        'calc': 'PER_UNIT',
        'unit': 'Operario',
        'price': 3500.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-LIMP-POST',
        'lineCode': 'SRV-LIMP-HOSP',
        'cat': 'Limpieza',
        'concept': 'Limpieza Profunda Post-Construcción / Entrega de Obra',
        'calc': 'PER_AREA',
        'unit': 'm²',
        'price': 25.0,
        'minQty': 50.0,
        'meta': jsonEncode({'productivityM2PerHour': 80}),
      },
      {
        'code': 'CAT-LIMP-TANQ',
        'lineCode': 'SRV-LIMP-HOSP',
        'cat': 'Limpieza',
        'concept': 'Lavado y Desinfección Profunda de Tanques de Agua Potable',
        'calc': 'PER_UNIT',
        'unit': 'Tanque',
        'price': 1800.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-LIMP-PIS',
        'lineCode': 'SRV-LIMP-HOSP',
        'cat': 'Limpieza',
        'concept': 'Pulido, Sellado y Vitrificado de Pisos de Alto Tráfico',
        'calc': 'PER_AREA',
        'unit': 'm²',
        'price': 35.0,
        'minQty': 50.0,
        'meta': jsonEncode({'productivityM2PerHour': 40}),
      },
      {
        'code': 'CAT-MANT-GEN',
        'lineCode': 'SRV-MANT-CORP',
        'cat': 'Mantenimiento',
        'concept': 'Mantenimiento Preventivo y Calibración Grupo Electrógeno',
        'calc': 'GLOBAL',
        'unit': 'Global',
        'price': 4200.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-MANT-BOM',
        'lineCode': 'SRV-MANT-CORP',
        'cat': 'Mantenimiento',
        'concept': 'Inspección y Reparación Bombas Hidroneumáticas',
        'calc': 'GLOBAL',
        'unit': 'Servicio',
        'price': 2000.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-JARD-ESP',
        'lineCode': 'SRV-MANT-JARD',
        'cat': 'Mantenimiento',
        'concept': 'Jardinero Especializado (Poda, abono y riego)',
        'calc': 'PER_UNIT',
        'unit': 'Operario',
        'price': 2200.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-EQ-RAD',
        'lineCode': 'SRV-EQ-RAD',
        'cat': 'Equipamiento',
        'concept': 'Kit Radios VHF Motorola + Base y Cargador',
        'calc': 'PER_UNIT',
        'unit': 'Kit',
        'price': 500.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-TEC-CAM',
        'lineCode': 'SRV-TEC-CAM',
        'cat': 'Tecnología',
        'concept': 'Cámara IP Dahua 4K IA Reconocimiento Facial y LPR',
        'calc': 'PER_UNIT',
        'unit': 'Unid.',
        'price': 2500.0,
        'minQty': 1.0,
      },
      {
        'code': 'CAT-TEC-RON',
        'lineCode': 'SRV-TEC-CAM',
        'cat': 'Tecnología',
        'concept': 'Rondín Electrónico RFID con Reportes en Tiempo Real',
        'calc': 'PER_UNIT',
        'unit': 'Servicio',
        'price': 400.0,
        'minQty': 1.0,
      },
    ];

    final Map<String, int> catalogIdByCode = {};
    for (final item in catalogData) {
      final existing = await CrmCatalogItem.db.findFirstRow(
        session,
        where: (t) => t.code.equals(item['code'] as String),
      );

      if (existing != null) {
        catalogIdByCode[item['code'] as String] = existing.id!;
      } else {
        final lineId =
            lineIdByCode[item['lineCode'] as String] ??
            lineIdByCode.values.first;

        final inserted = await repo.createCatalogItem(
          CrmCatalogItem(
            code: item['code'] as String,
            serviceLineId: lineId,
            category: item['cat'] as String,
            concept: item['concept'] as String,
            calculationType: item['calc'] as String,
            unitType: item['unit'] as String,
            basePrice: item['price'] as double,
            minQuantity: item['minQty'] as double,
            version: 1,
            metadata: item['meta'] as String?,
            isActive: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        catalogIdByCode[item['code'] as String] = inserted.id!;
      }
    }

    // =========================================================================
    // 4. TARIFAS DIFERENCIADAS (SCOPES) POR RUBRO
    // =========================================================================
    final saludSectorId = sectorIdByCode['SEC-SALUD'];
    if (saludSectorId != null) {
      // Limpieza Post-Construcción en Clínicas: 35.0 Bs/m² (Bioseguridad hospitalaria)
      final postConstId = catalogIdByCode['CAT-LIMP-POST'];
      if (postConstId != null) {
        await repo.setCatalogItemScope(
          CrmCatalogItemScope(
            catalogItemId: postConstId,
            sectorId: saludSectorId,
            priceOverride: 35.0,
            minQuantityOverride: 80.0,
            metadataOverride: jsonEncode({
              'grade': 'Hospitalario',
              'sterilization': true,
            }),
            isActive: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }

      // Pulido y Sellado en Clínicas: 45.0 Bs/m²
      final pisId = catalogIdByCode['CAT-LIMP-PIS'];
      if (pisId != null) {
        await repo.setCatalogItemScope(
          CrmCatalogItemScope(
            catalogItemId: pisId,
            sectorId: saludSectorId,
            priceOverride: 45.0,
            minQuantityOverride: 60.0,
            metadataOverride: jsonEncode({'grade': 'Quirúrgico epóxico'}),
            isActive: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }
    }

    session.log(
      'Seed de Catálogo y Tarifario culminado exitosamente.',
      level: LogLevel.info,
    );
  }
}
