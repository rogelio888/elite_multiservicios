import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_assignment_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_personnel_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'RRHH Assignments, Schedules & Rotation Integration Tests',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      test(
        'Flujo completo de Fase 4: Horarios, Asignación Operativa, Rotación Inmutable y Trazabilidad',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rrhhAssignment',
                    method: 'listAssignments',
                  )
                  as Session;

          final operationsRepo = RrhhOperationsRepository(session);
          final personnelRepo = RrhhPersonnelRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final now = DateTime.now().toUtc();

          // ===================================================================
          // 1. CREACIÓN DE HORARIO / TURNO
          // ===================================================================
          final schedule = await operationsRepo.createSchedule(
            RrhhSchedule(
              code: 'SCH-TEST-$timestamp',
              name: 'Turno Prueba $timestamp',
              targetType: 'CAMPO',
              startTime: '07:30',
              endTime: '15:30',
              workDays: [1, 2, 3, 4, 5, 6],
              toleranceMinutes: 10,
              isNightShift: false,
              description: 'Turno de prueba de integración de Fase 4.',
              isActive: true,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );

          expect(schedule.id, isNotNull);
          expect(schedule.code, 'SCH-TEST-$timestamp');
          expect(schedule.toleranceMinutes, 10);

          // Listar turnos filtrando por tipo CAMPO
          final schedules = await operationsRepo.listSchedules(
            targetType: 'CAMPO',
            search: 'Turno Prueba $timestamp',
          );
          expect(schedules.any((s) => s.id == schedule.id), isTrue);

          // ===================================================================
          // 2. CREACIÓN DE EMPLEADO BASE PARA ASIGNAR
          // ===================================================================
          final employee = await personnelRepo.createEmployee(
            RrhhEmployee(
              code: 'EMP-ASG-$timestamp',
              fullName: 'Colaborador Para Asignación $timestamp',
              birthPlace: 'Santa Cruz de la Sierra',
              identityCard: '$timestamp ASG',
              phone: '+591 71122334',
              address: 'Barrio Equipetrol Calle 4',
              occupation: 'Técnico Operativo',
              personalReference: 'Carlos Test',
              referencePhone: '+591 71199882',
              employeeType: 'CAMPO',
              area: 'Operaciones',
              position: 'Técnico de Mantenimiento',
              specialty: 'Mantenimiento General',
              workplace: 'Pendiente de Asignación',
              supervisor: 'Ricardo Montaño Justiniano',
              realStartDate: now,
              fiscalStartDate: now,
              agreedSalary: 3800.0,
              contractType: 'Indefinido',
              status: 'ACTIVO',
              availabilityStatus: 'DISPONIBLE',
              paymentModality: 'MENSUAL',
              workScheduleType: 'TIEMPO_COMPLETO_48H',
              createdAt: now,
              updatedAt: now,
            ),
          );

          expect(employee.id, isNotNull);
          expect(employee.availabilityStatus, 'DISPONIBLE');

          // ===================================================================
          // 3. ASIGNACIÓN OPERATIVA INICIAL
          // ===================================================================
          final initialAssignment = await operationsRepo.createAssignment(
            RrhhAssignment(
              code: 'ASG-T1-$timestamp',
              employeeId: employee.id!,
              employeeCode: employee.code,
              employeeName: employee.fullName,
              assignmentType: 'CAMPO',
              customerId: 101,
              customerCompanyName: 'Empresa Test Alfa',
              workplaceBranch: 'Sede: Parque Industrial',
              contractedServiceName: 'Mantenimiento Preventivo',
              supervisorName: 'Ricardo Montaño Justiniano',
              scheduleId: schedule.id!,
              scheduleName: schedule.name,
              startDate: now,
              status: 'ACTIVA',
              rotationNumber: 0,
              originDescription: 'Puesto Inicial',
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );

          expect(initialAssignment.id, isNotNull);
          expect(initialAssignment.status, 'ACTIVA');
          expect(initialAssignment.rotationNumber, 0);

          // Verificar que el empleado se actualizó a 'ASIGNADO'
          final updatedEmployee1 = await personnelRepo.getEmployeeById(employee.id!);
          expect(updatedEmployee1?.availabilityStatus, 'ASIGNADO');
          expect(updatedEmployee1?.workplace, contains('Empresa Test Alfa'));

          // ===================================================================
          // 4. ROTACIÓN OPERATIVA INMUTABLE (PROHIBIDO SOBREESCRIBIR)
          // ===================================================================
          final rotatedAssignment = await operationsRepo.rotateAssignment(
            currentAssignmentId: initialAssignment.id!,
            newAssignmentType: 'CAMPO',
            newCustomerId: 102,
            newCustomerCompanyName: 'Empresa Test Beta',
            newWorkplaceBranch: 'Sede: Centro Financiero',
            newContractedServiceName: 'Limpieza Integral y Desinfección',
            newScheduleId: schedule.id!,
            newSupervisorName: 'Ricardo Montaño Justiniano',
            rotationReason: 'Rotación programada por requerimiento de cliente.',
          );

          expect(rotatedAssignment.id, isNotNull);
          expect(rotatedAssignment.rotationNumber, 1);
          expect(rotatedAssignment.status, 'ACTIVA');
          expect(rotatedAssignment.originDescription, contains('Empresa Test Alfa'));

          // Verificar que la asignación anterior quedó FINALIZADA
          final previousAssignment = await operationsRepo.getAssignmentById(initialAssignment.id!);
          expect(previousAssignment?.status, 'FINALIZADA');
          expect(previousAssignment?.endDate, isNotNull);

          // ===================================================================
          // 5. HISTORIAL DE ROTACIONES Y LÍNEA DE TIEMPO
          // ===================================================================
          final history = await operationsRepo.getRotationHistory(employee.id!);
          expect(history.length, 2);
          expect(history.first.rotationNumber, 1);
          expect(history.last.rotationNumber, 0);

          // Verificar eventos en la línea de tiempo del empleado
          final timelineEvents = await personnelRepo.listTimelineEvents(employee.id!);
          expect(timelineEvents.any((e) => e.category == 'ASIGNACION' && e.title.contains('Asignación Inicial')), isTrue);
          expect(timelineEvents.any((e) => e.category == 'ASIGNACION' && e.title.contains('Rotación #1')), isTrue);

          // ===================================================================
          // 6. CANCELACIÓN DE ASIGNACIÓN Y LIBERACIÓN DE DISPONIBILIDAD
          // ===================================================================
          final cancelled = await operationsRepo.cancelAssignment(
            rotatedAssignment.id!,
            reason: 'Término de contrato con cliente.',
          );
          expect(cancelled, isTrue);

          final cancelledAssignment = await operationsRepo.getAssignmentById(rotatedAssignment.id!);
          expect(cancelledAssignment?.status, 'CANCELADA');

          final finalEmployee = await personnelRepo.getEmployeeById(employee.id!);
          expect(finalEmployee?.availabilityStatus, 'DISPONIBLE');
        },
      );
    },
  );
}
