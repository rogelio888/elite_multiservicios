import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/crm/data/crm_agenda_service.dart';

void main() {
  group('CrmAgendaService Unit Tests', () {
    late CrmAgendaService service;

    setUp(() {
      service = CrmAgendaService();
      service.initDefaultTasksForTesting();
    });

    test('initializes with realistic commercial tasks and calculates KPIs', () {
      expect(service.tasks.isNotEmpty, isTrue);
      expect(service.totalTasks, greaterThanOrEqualTo(5));
      expect(service.todayTasksCount, greaterThan(0));
      expect(service.overdueTasksCount, greaterThan(0));

      // Verifica que existan tareas de tipo llamada y cotización
      final taskTypes = service.tasks.map((t) => t.taskType).toSet();
      expect(taskTypes.contains(CrmTaskType.call), isTrue);
      expect(taskTypes.contains(CrmTaskType.quotation), isTrue);
    });

    test('addTask properly adds a task with callContext and phone', () {
      final initialCount = service.totalTasks;
      final now = DateTime.now();

      final newTask = CrmTaskItem(
        id: 'TSK-TEST-01',
        title: 'Llamar al encargado de compras a las 16:00',
        taskType: CrmTaskType.call,
        clientName: 'Condominio Sevilla Real',
        contactPerson: 'Lic. Andrés Hurtado',
        phone: '77123456',
        scheduledAt: DateTime(now.year, now.month, now.day),
        scheduledTimeText: '16:00',
        priority: 'Alta / Urgente',
        callContext: 'El encargado llega a las 4, llamar a esa hora puntual.',
        createdAt: now,
      );

      service.addTask(newTask);

      expect(service.totalTasks, equals(initialCount + 1));
      final stored = service.tasks.firstWhere((t) => t.id == 'TSK-TEST-01');
      expect(stored.clientName, equals('Condominio Sevilla Real'));
      expect(stored.phone, equals('77123456'));
      expect(stored.callContext, contains('El encargado llega a las 4'));
      expect(stored.isToday, isTrue);
    });

    test(
      'toggleTaskCompleted switches status between Pendiente and Completada',
      () {
        final task = service.tasks.firstWhere((t) => !t.isCompleted);
        final initialCompleted = service.completedTasksCount;

        service.toggleTaskCompleted(task.id);
        final updated = service.tasks.firstWhere((t) => t.id == task.id);
        expect(updated.isCompleted, isTrue);
        expect(service.completedTasksCount, equals(initialCompleted + 1));

        // Toggle back
        service.toggleTaskCompleted(task.id);
        final restored = service.tasks.firstWhere((t) => t.id == task.id);
        expect(restored.isCompleted, isFalse);
        expect(service.completedTasksCount, equals(initialCompleted));
      },
    );

    test('postponeTask updates scheduledAt and sets status to Pospuesta', () {
      final task = service.tasks.firstWhere(
        (t) => t.scheduledAt.isAfter(DateTime.now()),
        orElse: () => service.tasks.first,
      );
      final originalDate = task.scheduledAt;

      service.postponeTask(
        task.id,
        const Duration(days: 1),
        reason: 'Cliente pidió llamar mañana',
      );

      final updated = service.tasks.firstWhere((t) => t.id == task.id);
      expect(updated.status, equals('Pospuesta'));
      expect(
        updated.scheduledAt,
        equals(originalDate.add(const Duration(days: 1))),
      );
      expect(updated.notes, contains('Cliente pidió llamar mañana'));
    });

    test('getTasksForDate filters exclusively for the requested day', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayTasks = service.getTasksForDate(today);

      for (final t in todayTasks) {
        expect(t.isSameDay(today), isTrue);
      }
    });

    test(
      'scheduleQualityCheckTask automatically schedules post-sale quality audit after 72h',
      () {
        final initialCount = service.totalTasks;
        service.scheduleQualityCheckTask(
          customerId: 'CLI-PALMAS-01',
          contractId: 'CTR-PALMAS-01',
          clientName: 'Condominio Las Palmas Real',
          contactPerson: 'Lic. Marcelo Justiniano',
          phone: '77312890',
          contractTitle: 'Mantenimiento de Piscinas y Áreas Húmedas',
        );

        expect(service.totalTasks, equals(initialCount + 1));
        final task = service.tasks.firstWhere(
          (t) => t.relatedContractId == 'CTR-PALMAS-01',
        );
        expect(task.taskType, equals(CrmTaskType.postSale));
        expect(task.customerId, equals('CLI-PALMAS-01'));
        expect(task.priority, equals('Alta / Urgente'));
        expect(task.title, contains('Control de calidad'));
        expect(task.callContext, contains('verificación de satisfacción'));
      },
    );

    test(
      'scheduleRenewalTask schedules renewal reminder ahead of expiration',
      () {
        final initialCount = service.totalTasks;
        service.scheduleRenewalTask(
          customerId: 'CLI-SANTA-CRUZ-01',
          contractId: 'CTR-SECURITY-01',
          clientName: 'Edificio Torre Duo',
          contactPerson: 'Arq. Gabriela Soto',
          phone: '78899001',
          contractTitle: 'Seguridad Integral 24/7',
          expiryDate: DateTime.now().add(const Duration(days: 45)),
        );

        expect(service.totalTasks, equals(initialCount + 1));
        final task = service.tasks.firstWhere(
          (t) => t.relatedContractId == 'CTR-SECURITY-01',
        );
        expect(task.taskType, equals(CrmTaskType.renewal));
        expect(task.customerId, equals('CLI-SANTA-CRUZ-01'));
        expect(task.title, contains('Renovación de Contrato'));
        expect(task.callContext, contains('El contrato vencerá próximamente'));
      },
    );

    test('deleteTask removes task from local memory and updates counts', () async {
      final initialCount = service.totalTasks;
      final targetTask = service.tasks.first;
      final targetId = targetTask.id;

      await service.deleteTask(targetId);

      expect(service.totalTasks, equals(initialCount - 1));
      expect(service.tasks.any((t) => t.id == targetId), isFalse);
    });
  });
}
