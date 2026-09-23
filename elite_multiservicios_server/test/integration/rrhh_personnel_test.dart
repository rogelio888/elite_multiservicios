import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_personnel_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_applicant_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'RRHH Personnel & Employee Dossier Integration Tests',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      test(
        'Flujo completo de Empleados: Expediente, Contratación desde Postulante, Documentos, Disponibilidad y Desvinculación',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rrhhPersonnel',
                    method: 'listEmployees',
                  )
                  as Session;

          final personnelRepo = RrhhPersonnelRepository(session);
          final applicantRepo = RrhhRecruitmentRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // ===================================================================
          // 1. CREACIÓN DIRECTA DE EMPLEADO
          // ===================================================================
          final directEmployee = await personnelRepo.createEmployee(
            RrhhEmployee(
              code: 'AUTO',
              fullName: 'Empleado Test Directo $timestamp',
              birthPlace: 'Santa Cruz de la Sierra',
              identityCard: '$timestamp SCZ',
              phone: '+591 70011223',
              address: 'Av. Beni Calle 5 #30',
              occupation: 'Técnico Especialista',
              personalReference: 'Ana Test',
              referencePhone: '+591 70099887',
              employeeType: 'CAMPO',
              area: 'Operaciones',
              position: 'Técnico de Mantenimiento',
              specialty: 'Mantenimiento Electromecánico',
              workplace: 'Kolping - Central',
              supervisor: 'Ricardo Montaño Justiniano',
              realStartDate: DateTime.now().toUtc(),
              fiscalStartDate: DateTime.now().toUtc(),
              agreedSalary: 4200.0,
              contractType: 'Indefinido',
              observations: 'Empleado creado para verificación de pruebas.',
              status: 'ACTIVO',
              availabilityStatus: 'DISPONIBLE',
              paymentModality: 'MENSUAL',
              workScheduleType: 'TIEMPO_COMPLETO_48H',
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          expect(directEmployee.id, isNotNull);
          expect(directEmployee.code, startsWith('EMP-'));
          expect(directEmployee.status, equals('ACTIVO'));
          expect(directEmployee.availabilityStatus, equals('DISPONIBLE'));
          expect(directEmployee.corporateEmail, contains('@elitemultiservicios.com'));

          // ===================================================================
          // 2. DOCUMENTOS ADJUNTOS
          // ===================================================================
          final doc = await personnelRepo.addDocument(
            RrhhEmployeeDocument(
              employeeId: directEmployee.id!,
              documentType: 'CI',
              title: 'Cédula de Identidad Anverso y Reverso',
              fileUrl: 'https://storage.elitemultiservicios.com/docs/ci_$timestamp.pdf',
              fileName: 'ci_$timestamp.pdf',
              fileSizeBytes: 204800,
              mimeType: 'application/pdf',
              isVerified: true,
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
          expect(doc.id, isNotNull);

          final docsList = await personnelRepo.listDocuments(directEmployee.id!);
          expect(docsList.any((d) => d.id == doc.id), isTrue);

          // ===================================================================
          // 3. CONTRATACIÓN TRANSACCIONAL DESDE POSTULANTE
          // ===================================================================
          final applicant = await applicantRepo.createApplicant(
            RrhhApplicant(
              code: 'AUTO',
              fullName: 'Postulante Seleccionado $timestamp',
              identityCard: '${timestamp}B SCZ',
              phone: '+591 71092834',
              targetType: 'CAMPO',
              targetArea: 'Operaciones',
              targetPosition: 'Jardinero',
              specialty: 'Jardinería & Paisajismo',
              applicationDate: DateTime.now().toUtc(),
              status: 'SELECCIONADO',
              hasCvAttached: true,
              hasIdentityCardCopy: true,
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          final hiredEmployee = await personnelRepo.hireApplicant(
            applicantId: applicant.id!,
            realStartDate: DateTime.now().toUtc(),
            fiscalStartDate: DateTime.now().toUtc(),
            agreedSalary: 2900.0,
            contractType: 'Plazo Fijo',
            workplace: 'Ventura Mall - Principal',
            supervisor: 'Ricardo Montaño Justiniano',
            observations: 'Contratado formalmente tras superar evaluación.',
          );

          expect(hiredEmployee.id, isNotNull);
          expect(hiredEmployee.applicantId, equals(applicant.id));
          expect(hiredEmployee.status, equals('ACTIVO'));
          expect(hiredEmployee.agreedSalary, equals(2900.0));

          // Verificar que el postulante quedó marcado como 'CONTRATADO'
          final updatedApplicant = await applicantRepo.getApplicantById(applicant.id!);
          expect(updatedApplicant!.status, equals('CONTRATADO'));

          // ===================================================================
          // 4. ACTUALIZACIÓN DE DISPONIBILIDAD PARA OPERACIONES
          // ===================================================================
          final assignedEmployee = await personnelRepo.updateAvailabilityStatus(
            hiredEmployee.id!,
            newAvailabilityStatus: 'ASIGNADO',
          );
          expect(assignedEmployee.availabilityStatus, equals('ASIGNADO'));

          // ===================================================================
          // 5. LÍNEA DE TIEMPO / HISTORIAL CONSERVADO
          // ===================================================================
          final timeline = await personnelRepo.listTimelineEvents(hiredEmployee.id!);
          expect(timeline.isNotEmpty, isTrue);
          expect(timeline.any((e) => e.category == 'CONTRATACION'), isTrue);

          // ===================================================================
          // 6. DESVINCULACIÓN LABORAL (SIN BORRADO FÍSICO)
          // ===================================================================
          final terminated = await personnelRepo.terminateEmployee(
            hiredEmployee.id!,
            exitDate: DateTime.now().toUtc(),
            exitReason: 'Renuncia voluntaria por motivos personales',
            exitObservations: 'Entrega de puesto y credenciales al día.',
            registeredBy: 'Paola Andrea Torrico Vaca',
          );

          expect(terminated.status, equals('INACTIVO'));
          expect(terminated.availabilityStatus, equals('SUSPENDIDO'));
          expect(terminated.exitReason, contains('Renuncia voluntaria'));

          // Verificar que el expediente sigue existiendo y accesible
          final retrievedInDb = await personnelRepo.getEmployeeById(hiredEmployee.id!);
          expect(retrievedInDb, isNotNull);
          expect(retrievedInDb!.status, equals('INACTIVO'));
          expect(retrievedInDb.isDeleted, isFalse);

          // Verificar que se agregó el evento de desvinculación
          final timelineAfterExit = await personnelRepo.listTimelineEvents(hiredEmployee.id!);
          expect(timelineAfterExit.any((e) => e.category == 'DESVINCULACION'), isTrue);
        },
      );
    },
  );
}
