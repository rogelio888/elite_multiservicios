import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_timeline_event.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_mock_dataset.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';

void main() {
  late RrhhRepositoryMock repository;

  setUp(() {
    repository = RrhhRepositoryMock();
  });

  group('Pantalla 14 — Bloque 4: Bitácora de Movimientos (Unit Tests)', () {
    test('Mock dataset contiene más de 30 eventos coherentes y ordenados', () {
      final initialEvents = RrhhMockDataset.initialTimelineEvents();
      expect(initialEvents.length, greaterThanOrEqualTo(30));

      // Verifica que todos tengan código generado y metadatos válidos
      for (final ev in initialEvents) {
        expect(ev.code, startsWith('EVT-'));
        expect(ev.category, isNotEmpty);
        expect(ev.registeredBy, isNotEmpty);
      }
    });

    test('listTimelineEvents retorna lista ordenada por fecha DESC', () async {
      final events = await repository.listTimelineEvents();
      expect(events, isNotEmpty);

      for (int i = 0; i < events.length - 1; i++) {
        expect(
          events[i].date.isAfter(events[i + 1].date) ||
              events[i].date.isAtSameMomentAs(events[i + 1].date),
          isTrue,
        );
      }
    });

    test('Filtro por categoría opera correctamente', () async {
      final vacEvents = await repository.listTimelineEvents(category: 'VACACIONES');
      expect(vacEvents, isNotEmpty);
      expect(vacEvents.every((e) => e.category == 'VACACIONES'), isTrue);

      final incEvents = await repository.listTimelineEvents(category: 'INCIDENCIA');
      expect(incEvents, isNotEmpty);
      expect(incEvents.every((e) => e.category == 'INCIDENCIA'), isTrue);
    });

    test('Filtro por usuario responsable opera correctamente', () async {
      final activeUsers = repository.listActiveUsers();
      expect(activeUsers, isNotEmpty);

      final testUser = activeUsers.first;
      final userEvents = await repository.listTimelineEvents(user: testUser);
      expect(userEvents, isNotEmpty);
      expect(userEvents.every((e) => e.registeredBy == testUser), isTrue);
    });

    test('Filtro por empleado ID filtra solo movimientos de dicho colaborador', () async {
      final empEvents = await repository.listTimelineEvents(employeeId: 1);
      expect(empEvents, isNotEmpty);
      expect(empEvents.every((e) => e.employeeId == 1), isTrue);
    });

    test('Búsqueda textual localiza por código, título, usuario o descripción', () async {
      final searchCode = await repository.listTimelineEvents(search: 'EVT-000001');
      expect(searchCode, isNotEmpty);
      expect(searchCode.any((e) => e.id == 1), isTrue);

      final searchTitle = await repository.listTimelineEvents(search: 'Vacaciones');
      expect(searchTitle, isNotEmpty);
      expect(searchTitle.every((e) => e.title.toLowerCase().contains('vacaciones') || e.category.toLowerCase().contains('vacaciones')), isTrue);
    });

    test('RrhhTimelineCategory expone categorías oficiales y etiquetas legibles', () {
      final cats = repository.listTimelineCategories();
      expect(cats, contains('CONTRATACION'));
      expect(cats, contains('INCIDENCIA'));
      expect(cats, contains('DESVINCULACION'));
      expect(cats, contains('SALARIOS'));

      expect(RrhhTimelineCategory.getLabel('CONTRATACION'), 'Contratación / Altas');
      expect(RrhhTimelineCategory.getLabel('DESVINCULACION'), 'Desvinculaciones');
      expect(RrhhTimelineCategory.getLabel('SALARIOS'), 'Salarios y Nómina');
    });

    test('Extensión de auditoría soporta cambios de campo y documentos adjuntos', () {
      final event = RrhhTimelineEvent(
        id: 999,
        employeeId: 1,
        date: DateTime(2026, 9, 27, 10, 0),
        title: 'Nivelación Salarial Test',
        description: 'Ajuste de prueba para unit test',
        category: 'CONTRATUAL',
        registeredBy: 'Auditor Test',
        createdAt: DateTime(2026, 9, 27, 10, 0),
      ).withAuditMetadata(
        sourceType: 'CONTRACT',
        sourceId: 99,
        sourceCode: 'CTR-TEST-99',
        employeeName: 'Juan Carlos Pérez',
        employeeCode: 'EMP-001',
        userRole: 'Auditor Senior',
        ipAddress: '127.0.0.1',
        fieldChanges: [
          const RrhhAuditFieldChange(
            fieldName: 'Haber Básico',
            oldValue: 'Bs 4,000.00',
            newValue: 'Bs 4,500.00',
          ),
        ],
        documents: ['Resolucion_Test.pdf'],
      );

      expect(event.code, 'EVT-000999');
      expect(event.sourceType, 'CONTRACT');
      expect(event.sourceCode, 'CTR-TEST-99');
      expect(event.employeeName, 'Juan Carlos Pérez');
      expect(event.userRole, 'Auditor Senior');
      expect(event.ipAddress, '127.0.0.1');
      expect(event.fieldChanges?.length, 1);
      expect(event.fieldChanges?.first.fieldName, 'Haber Básico');
      expect(event.documents?.first, 'Resolucion_Test.pdf');
    });
  });
}
