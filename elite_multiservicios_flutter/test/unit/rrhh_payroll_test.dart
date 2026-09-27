import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_payroll_period.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';

void main() {
  late RrhhRepositoryMock repo;

  setUp(() {
    repo = RrhhRepositoryMock();
  });

  group('Pantalla 12 — Bloque 4: Novedades para Nómina (Unit Tests)', () {
    test('El mock contiene períodos pre-poblados ordenados cronológicamente', () async {
      final periods = await repo.listPayrollPeriods();
      expect(periods.length, greaterThanOrEqualTo(2));

      // Septiembre 2026 es el más reciente (abierto)
      final sep = periods.firstWhere((p) => p.year == 2026 && p.month == 9);
      expect(sep.code, equals('NOM-2026-09'));
      expect(sep.status, equals(RrhhPayrollPeriodStatus.abierto));
      expect(sep.isOpen, isTrue);

      // Agosto 2026 está enviado
      final aug = periods.firstWhere((p) => p.year == 2026 && p.month == 8);
      expect(aug.code, equals('NOM-2026-08'));
      expect(aug.status, equals(RrhhPayrollPeriodStatus.enviado));
      expect(aug.isSent, isTrue);
    });

    test('Consolida items de novedades del período actual con los 4 tipos de fuentes', () async {
      final sep = await repo.getPayrollPeriodByMonth(2026, 9);
      expect(sep, isNotNull);

      final items = await repo.listPayrollItems(sep!.id);
      expect(items, isNotEmpty);

      // Verificar existencia de las 4 fuentes
      final hasPermiso = items.any((i) => i.sourceType == RrhhPayrollSourceType.permiso);
      final hasVacacion = items.any((i) => i.sourceType == RrhhPayrollSourceType.vacacion);
      final hasIncidencia = items.any((i) => i.sourceType == RrhhPayrollSourceType.incidencia);
      final hasDesvinculacion = items.any((i) => i.sourceType == RrhhPayrollSourceType.desvinculacion);

      expect(hasPermiso, isTrue);
      expect(hasVacacion, isTrue);
      expect(hasIncidencia, isTrue);
      expect(hasDesvinculacion, isTrue);

      // Verificar impactos económicos
      final deductions = items.where((i) => i.impactType == RrhhPayrollImpactType.descuento).toList();
      final extraPayments = items.where((i) => i.impactType == RrhhPayrollImpactType.pagoExtra).toList();
      final noImpacts = items.where((i) => i.impactType == RrhhPayrollImpactType.sinImpacto).toList();

      expect(deductions, isNotEmpty);
      expect(extraPayments, isNotEmpty);
      expect(noImpacts, isNotEmpty);
    });

    test('Filtros por sourceType e impactType operan correctamente', () async {
      final sep = await repo.getPayrollPeriodByMonth(2026, 9);
      expect(sep, isNotNull);

      final allItems = await repo.listPayrollItems(sep!.id);
      final permisoItems = await repo.listPayrollItems(sep.id, sourceType: RrhhPayrollSourceType.permiso);
      final discountItems = await repo.listPayrollItems(sep.id, impactType: RrhhPayrollImpactType.descuento);

      expect(permisoItems.length, lessThanOrEqualTo(allItems.length));
      expect(permisoItems.every((i) => i.sourceType == RrhhPayrollSourceType.permiso), isTrue);
      expect(discountItems.every((i) => i.impactType == RrhhPayrollImpactType.descuento), isTrue);
    });

    test('Ciclo de vida del período: cerrar y enviar a Contabilidad', () async {
      final sep = await repo.getPayrollPeriodByMonth(2026, 9);
      expect(sep, isNotNull);
      expect(sep!.isOpen, isTrue);

      // No se puede enviar a Contabilidad si aún está abierto
      expect(
        () => repo.sendPayrollPeriodToAccounting(sep.id),
        throwsA(isA<StateError>()),
      );

      // Cerrar período
      final closedPeriod = await repo.closePayrollPeriod(
        sep.id,
        closedBy: 'Lic. Laura Mendoza',
        notes: 'Cierre preliminar aprobado para contabilidad.',
      );
      expect(closedPeriod.status, equals(RrhhPayrollPeriodStatus.cerrado));
      expect(closedPeriod.isClosed, isTrue);
      expect(closedPeriod.closedAt, isNotNull);
      expect(closedPeriod.closedBy, equals('Lic. Laura Mendoza'));

      // Ahora sí se puede enviar a Contabilidad
      final sentPeriod = await repo.sendPayrollPeriodToAccounting(
        sep.id,
        sentBy: 'Lic. Laura Mendoza',
      );
      expect(sentPeriod.status, equals(RrhhPayrollPeriodStatus.enviado));
      expect(sentPeriod.isSent, isTrue);
      expect(sentPeriod.sentAt, isNotNull);
    });

    test('Exportación a CSV y Excel produce cadenas formateadas válidas', () async {
      final sep = await repo.getPayrollPeriodByMonth(2026, 9);
      expect(sep, isNotNull);

      final csv = await repo.exportPayrollPeriod(sep!.id, 'csv');
      expect(csv, contains('PERIODO,EMPLEADO_CODIGO,EMPLEADO_NOMBRE'));
      expect(csv, contains('NOM-2026-09'));

      final excel = await repo.exportPayrollPeriod(sep.id, 'excel');
      expect(excel, contains('REPORTE CONSOLIDADO DE NOVEDADES PARA NOMINA — NOM-2026-09'));
      expect(excel, contains('Empleado\tTipo\tCódigo'));
    });

    test('Creación de nuevo período previene duplicados y genera items automáticamente', () async {
      // Intentar crear septiembre 2026 nuevamente debe fallar
      expect(
        () => repo.createPayrollPeriod(2026, 9),
        throwsA(isA<StateError>()),
      );

      // Crear período para octubre 2026
      final oct = await repo.createPayrollPeriod(2026, 10, notes: 'Período octubre 2026');
      expect(oct.code, equals('NOM-2026-10'));
      expect(oct.year, equals(2026));
      expect(oct.month, equals(10));
      expect(oct.status, equals(RrhhPayrollPeriodStatus.abierto));

      final items = await repo.listPayrollItems(oct.id);
      expect(items, isNotNull);
    });
  });
}
