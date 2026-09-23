import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_labor_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_personnel_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_assignment_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'RRHH Labor, Leaves, Vacations, Discipline & Termination Integration Tests',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      test(
        'Flujo completo de Fase 5: Licencias, Vacaciones Legales, Incidencias, Desvinculación Inmutable y Bitácora',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rrhhLabor',
                    method: 'listLeaveRequests',
                  )
                  as Session;

          final laborRepo = RrhhLaborRepository(session);
          final personnelRepo = RrhhPersonnelRepository(session);
          final operationsRepo = RrhhOperationsRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final now = DateTime.now().toUtc();

          // ===================================================================
          // 0. EMPLEADO BASE DE PRUEBA
          // ===================================================================
          final employee = await personnelRepo.createEmployee(
            RrhhEmployee(
              code: 'EMP-LAB-$timestamp',
              identityCard: '${timestamp.toString().substring(5)} SC',
              fullName: 'Colaborador Laboral Test $timestamp',
              birthDate: DateTime(1992, 4, 15).toUtc(),
              birthPlace: 'Santa Cruz de la Sierra',
              occupation: 'Supervisor de Seguridad',
              phone: '77123456',
              address: 'Av. Mutualista, Calle 3 #45, Santa Cruz',
              personalReference: 'Familiar Directo',
              referencePhone: '77123000',
              employeeType: 'CAMPO',
              area: 'Operaciones de Campo',
              position: 'Supervisor de Seguridad',
              specialty: 'Seguridad y Vigilancia',
              workplace: 'Ventura Mall',
              supervisor: 'Ing. Javier Torrico',
              realStartDate: now.subtract(
                const Duration(days: 800),
              ), // ~2.2 años
              fiscalStartDate: now.subtract(const Duration(days: 800)),
              agreedSalary: 3800.0,
              contractType: 'Indefinido',
              status: 'ACTIVO',
              availabilityStatus: 'DISPONIBLE',
              createdAt: now,
              updatedAt: now,
            ),
          );

          expect(employee.id, isNotNull);
          final empId = employee.id!;

          // Horario y asignación activa previa
          final schedule = await operationsRepo.createSchedule(
            RrhhSchedule(
              code: 'SCH-LAB-$timestamp',
              name: 'Turno Laboral $timestamp',
              targetType: 'CAMPO',
              startTime: '08:00',
              endTime: '16:00',
              workDays: [1, 2, 3, 4, 5],
              toleranceMinutes: 10,
              isNightShift: false,
              isActive: true,
              isDeleted: false,
              createdAt: now,
              updatedAt: now,
            ),
          );

          final assignment = await operationsRepo.createAssignment(
            RrhhAssignment(
              code: 'ASG-LAB-$timestamp',
              employeeId: empId,
              employeeCode: employee.code,
              employeeName: employee.fullName,
              assignmentType: 'CAMPO',
              customerId: 101,
              customerCompanyName: 'Ventura Mall S.A.',
              workplaceBranch: 'Sede Equipetrol',
              contractedServiceName: 'Seguridad Perimetral',
              supervisorName: 'Ing. Javier Torrico',
              scheduleId: schedule.id!,
              scheduleName: schedule.name,
              startDate: now.subtract(const Duration(days: 30)),
              status: 'ACTIVA',
              createdAt: now,
              updatedAt: now,
            ),
          );
          expect(assignment.status, 'ACTIVA');

          // ===================================================================
          // 1. GESTIÓN DE PERMISOS Y LICENCIAS
          // ===================================================================
          final leave = await laborRepo.createLeaveRequest(
            employeeId: empId,
            leaveType: 'MEDICA',
            startDate: now.subtract(const Duration(days: 2)),
            endDate: now.add(const Duration(days: 1)),
            daysCount: 3,
            reason: 'Baja médica por lumbalgia aguda certificada.',
            medicalCertificateNumber: 'CNS-TEST-$timestamp',
          );

          expect(leave.id, isNotNull);
          expect(leave.code, startsWith('LIC-'));
          expect(leave.status, 'PENDIENTE');
          expect(leave.daysCount, 3);

          // Aprobación de la licencia
          final resolvedLeave = await laborRepo.resolveLeaveRequest(
            leave.id!,
            status: 'APROBADO',
            resolutionNotes: 'Baja validada por médico laboral.',
            resolvedByUserId: 1,
          );
          expect(resolvedLeave.status, 'APROBADO');

          // Verificación de disponibilidad del colaborador (en curso)
          final updatedEmp1 = await personnelRepo.getEmployeeById(empId);
          expect(updatedEmp1?.availabilityStatus, 'CON_PERMISO');

          // ===================================================================
          // 2. CONTROL Y CÁLCULO DE VACACIONES SEGÚN LEY BOLIVIANA
          // ===================================================================
          // Con 2.2 años de servicio, le corresponden 15 días hábiles
          final entitlement = laborRepo.calculateVacationEntitlement(
            employee.realStartDate,
            now,
          );
          expect(entitlement, 15);

          // Solicitud de 7 días de vacación
          final vacation = await laborRepo.requestVacation(
            employeeId: empId,
            periodYear: now.year - 1,
            startDate: now.add(const Duration(days: 15)),
            endDate: now.add(const Duration(days: 22)),
            daysRequested: 7,
            notes: 'Vacaciones programadas de común acuerdo.',
          );

          expect(vacation.id, isNotNull);
          expect(vacation.code, startsWith('VAC-'));
          expect(vacation.status, 'SOLICITADA');
          expect(vacation.totalAccruedDays, 15);
          expect(vacation.remainingBalanceDays, 8); // 15 - 7 = 8

          // Aprobación de la vacación
          final approvedVacation = await laborRepo.approveVacation(
            vacation.id!,
            approvedByUserId: 1,
            notes: 'Aprobado formalmente por Gerencia.',
          );
          expect(approvedVacation.status, 'APROBADA');

          // ===================================================================
          // 3. RÉGIMEN DISCIPLINARIO E INCIDENCIAS
          // ===================================================================
          final incident = await laborRepo.recordIncident(
            employeeId: empId,
            incidentType: 'FELICITACION',
            severity: 'POSITIVA',
            incidentDate: now.subtract(const Duration(days: 5)),
            title: 'Intervención Oportuna en Sede',
            description:
                'Prevención de incidente de seguridad en acceso principal del cliente.',
            actionTaken:
                'Felicitación asentada en expediente con nota meritoria.',
            isJustified: true,
            recordedByUserId: 1,
          );

          expect(incident.id, isNotNull);
          expect(incident.code, startsWith('INC-'));
          expect(incident.severity, 'POSITIVA');

          final incidents = await laborRepo.listIncidents(employeeId: empId);
          expect(incidents.any((i) => i.id == incident.id), isTrue);

          // ===================================================================
          // 4. DESVINCULACIÓN FORMAL Y REGLA DE ORO DE AUDITORÍA
          // ===================================================================
          final termination = await laborRepo.terminateEmployee(
            employeeId: empId,
            terminationDate: now,
            lastWorkingDay: now,
            reason: 'FIN_DE_CONTRATO',
            detailedReason:
                'Conclusión regular del contrato con entrega satisfactoria de dotación.',
            severanceAmount: 3800.0,
            clearanceCompleted: true,
            isEligibleForRehire: true,
            processedByUserId: 1,
            handoverNotes:
                'Paz y salvo firmado y entrega total de llaves y uniforme.',
          );

          expect(termination.id, isNotNull);
          expect(termination.code, startsWith('DESV-'));
          expect(termination.reason, 'FIN_DE_CONTRATO');
          expect(termination.clearanceCompleted, isTrue);

          // REGLA DE ORO: El empleado pasa a INACTIVO, NO es eliminado físicamente
          final terminatedEmployee = await personnelRepo.getEmployeeById(empId);
          expect(terminatedEmployee, isNotNull);
          expect(terminatedEmployee?.status, 'INACTIVO');
          expect(terminatedEmployee?.availabilityStatus, 'NO_DISPONIBLE');
          expect(terminatedEmployee?.exitDate, isNotNull);
          expect(terminatedEmployee?.exitReason, 'FIN_DE_CONTRATO');

          // Asignaciones activas cerradas automáticamente
          final activeAssignments = await operationsRepo.listAssignments(
            employeeId: empId,
            status: 'ACTIVA',
          );
          expect(activeAssignments, isEmpty);

          final finalizedAssignments = await operationsRepo.listAssignments(
            employeeId: empId,
            status: 'FINALIZADA',
          );
          expect(finalizedAssignments.isNotEmpty, isTrue);
          expect(finalizedAssignments.first.id, assignment.id);

          // Bitácora inmutable de movimientos contiene el egreso
          final movements = await laborRepo.listMovements(employeeId: empId);
          expect(
            movements.any((m) => m.movementType == 'DESVINCULACION'),
            isTrue,
          );

          // Línea de tiempo contiene el hito de desvinculación
          final timeline = await personnelRepo.listTimelineEvents(empId);
          expect(timeline.any((e) => e.category == 'DESVINCULACION'), isTrue);
        },
      );
    },
  );
}
