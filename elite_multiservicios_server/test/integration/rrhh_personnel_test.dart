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
          expect(
            directEmployee.corporateEmail,
            contains('@elitemultiservicios.com'),
          );

          // ===================================================================
          // 2. DOCUMENTOS ADJUNTOS
          // ===================================================================
          final doc = await personnelRepo.addDocument(
            RrhhEmployeeDocument(
              employeeId: directEmployee.id!,
              documentType: 'CI',
              title: 'Cédula de Identidad Anverso y Reverso',
              fileUrl:
                  'https://storage.elitemultiservicios.com/docs/ci_$timestamp.pdf',
              fileName: 'ci_$timestamp.pdf',
              fileSizeBytes: 204800,
              mimeType: 'application/pdf',
              isVerified: true,
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
          expect(doc.id, isNotNull);

          final docsList = await personnelRepo.listDocuments(
            directEmployee.id!,
          );
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
          // agreedSalary es null en sesión sin permiso rrhh.compensation.view
          expect(hiredEmployee.agreedSalary, isNull);

          // Verificar que el postulante quedó marcado como 'CONTRATADO'
          final updatedApplicant = await applicantRepo.getApplicantById(
            applicant.id!,
          );
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
          final timeline = await personnelRepo.listTimelineEvents(
            hiredEmployee.id!,
          );
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
          final retrievedInDb = await personnelRepo.getEmployeeById(
            hiredEmployee.id!,
          );
          expect(retrievedInDb, isNotNull);
          expect(retrievedInDb!.status, equals('INACTIVO'));
          expect(retrievedInDb.isDeleted, isFalse);

          // Verificar que se agregó el evento de desvinculación
          final timelineAfterExit = await personnelRepo.listTimelineEvents(
            hiredEmployee.id!,
          );
          expect(
            timelineAfterExit.any((e) => e.category == 'DESVINCULACION'),
            isTrue,
          );
        },
      );

      test(
        'Flujo de Fase B: Actualizaciones granulares de expediente y exposición contractual',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rrhhPersonnel',
                    method: 'listEmployees',
                  )
                  as Session;

          final personnelRepo = RrhhPersonnelRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          final employee = await personnelRepo.createEmployee(
            RrhhEmployee(
              code: 'AUTO',
              fullName: 'Empleado Fase B $timestamp',
              birthPlace: 'Santa Cruz',
              identityCard: '$timestamp SCZ',
              phone: '+591 70001122',
              address: 'Av. Santos Dumont #400',
              occupation: 'Técnico',
              personalReference: 'Carlos Test',
              referencePhone: '+591 71122334',
              employeeType: 'CAMPO',
              area: 'Operaciones',
              position: 'Técnico de Limpieza',
              specialty: 'Industrial',
              workplace: 'Base Central',
              supervisor: 'Supervisor General',
              realStartDate: DateTime.now().toUtc(),
              fiscalStartDate: DateTime.now().toUtc(),
              agreedSalary: 3500.0,
              contractType: 'INDEFINIDO',
              status: 'ACTIVO',
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          final empId = employee.id!;

          // 1. updateEmployeeBankInfo
          final bankUpdated = await personnelRepo.updateEmployeeBankInfo(
            id: empId,
            bankName: 'Banco Mercantil Santa Cruz',
            accountType: 'CAJA_AHORRO',
            accountNumber: '4010203040',
            registeredBy: 'Admin Test',
          );
          expect(bankUpdated.bankName, equals('Banco Mercantil Santa Cruz'));
          expect(bankUpdated.accountType, equals('CAJA_AHORRO'));
          expect(bankUpdated.accountNumber, equals('4010203040'));

          // 2. updateEmployeeSocialSecurity
          final ssUpdated = await personnelRepo.updateEmployeeSocialSecurity(
            id: empId,
            afpName: 'Gestora Pública',
            afpNumber: '88776655',
            healthInsurance: 'Caja Nacional de Salud',
            registeredBy: 'Admin Test',
          );
          expect(ssUpdated.afpName, equals('Gestora Pública'));
          expect(ssUpdated.afpNumber, equals('88776655'));
          expect(ssUpdated.healthInsurance, equals('Caja Nacional de Salud'));

          // 3. updateEmployeePersonalInfo
          final piUpdated = await personnelRepo.updateEmployeePersonalInfo(
            id: empId,
            fullAddress: 'Calle Las Palmas #123, Barrio Sirari',
            maritalStatus: 'CASADO',
            childrenCount: 2,
            emergencyContactName: 'Laura Mendoza',
            emergencyContactPhone: '+591 79988776',
            emergencyContactRelation: 'Cónyuge',
            registeredBy: 'Admin Test',
          );
          expect(
            piUpdated.fullAddress,
            equals('Calle Las Palmas #123, Barrio Sirari'),
          );
          expect(piUpdated.maritalStatus, equals('CASADO'));
          expect(piUpdated.childrenCount, equals(2));
          expect(piUpdated.emergencyContactName, equals('Laura Mendoza'));

          // 4. updateEmployeeContract
          final contractStart = DateTime.now().toUtc();
          final cUpdated = await personnelRepo.updateEmployeeContract(
            id: empId,
            contractType: 'PLAZO_FIJO',
            workdayType: 'TIEMPO_COMPLETO_48H',
            paymentModality: 'MENSUAL',
            baseSalary: 4200.0,
            contractStartDate: contractStart,
            contractEndDate: null,
            contractSignedPdfUrl:
                'https://storage.example.com/contracts/EMP-999.pdf',
            bonuses: [
              RrhhEmployeeBonus(
                code: 'BON-001',
                name: 'Bono Productividad',
                type: 'FIJO',
                amount: 300.0,
              ),
            ],
            deductions: [
              RrhhEmployeeDeduction(
                code: 'DED-001',
                name: 'Aporte Sindical',
                type: 'FIJO',
                amount: 50.0,
              ),
            ],
            justification:
                'Modificación contractual debidamente aprobada por Gerencia General',
            registeredBy: 'Admin Test',
          );
          expect(cUpdated.contractType, equals('PLAZO_FIJO'));
          // agreedSalary es null en sesión sin permiso rrhh.compensation.view
          expect(cUpdated.agreedSalary, isNull);
          expect(cUpdated.contractSignedPdfUrl, contains('EMP-999.pdf'));

          // 5. updateEmployeeBonuses
          final bUpdated = await personnelRepo.updateEmployeeBonuses(
            id: empId,
            bonuses: [
              RrhhEmployeeBonus(
                code: 'BON-002',
                name: 'Bono Asistencia',
                type: 'FIJO',
                amount: 250.0,
              ),
            ],
            registeredBy: 'Admin Test',
          );
          expect(bUpdated.bonuses, isNull); // Enmascarado sin permiso

          // 6. updateEmployeeDeductions
          final dUpdated = await personnelRepo.updateEmployeeDeductions(
            id: empId,
            deductions: [
              RrhhEmployeeDeduction(
                code: 'DED-002',
                name: 'Anticipo',
                type: 'FIJO',
                amount: 200.0,
              ),
            ],
            registeredBy: 'Admin Test',
          );
          expect(dUpdated.deductions, isNull); // Enmascarado sin permiso

          // 7. updateEmployeeAssignment
          final aUpdated = await personnelRepo.updateEmployeeAssignment(
            id: empId,
            shiftId: 'TURNO_MANANA',
            baseLocation: 'Parque Industrial Lote 8',
            supervisorEmployeeId: 'EMP-005',
            registeredBy: 'Admin Test',
          );
          expect(aUpdated.shiftId, equals('TURNO_MANANA'));
          expect(aUpdated.baseLocation, equals('Parque Industrial Lote 8'));
          expect(aUpdated.supervisorEmployeeId, equals('EMP-005'));

          // 8. updateEmployeeDocuments
          final docUpdated = await personnelRepo.updateEmployeeDocuments(
            id: empId,
            documentChecklist: [
              RrhhDossierDocument(
                code: 'CI',
                name: 'Cédula de Identidad',
                isRequired: true,
                status: 'validado',
              ),
              RrhhDossierDocument(
                code: 'AFP',
                name: 'Certificado AFP',
                isRequired: true,
                status: 'validado',
              ),
            ],
            registeredBy: 'Admin Test',
          );
          expect(
            docUpdated.documentChecklist?.any((d) => d.code == 'CI'),
            isTrue,
          );

          // 9. getEmployeeContractData
          final contractData = await personnelRepo.getEmployeeContractData(
            empId,
          );
          expect(contractData.employeeId, equals(empId));
          expect(contractData.code, equals(employee.code));
          expect(contractData.baseSalary, isNull); // Enmascarado sin permiso
          expect(contractData.contractType, equals('PLAZO_FIJO'));
          expect(contractData.paymentModality, equals('MENSUAL'));

          // 10. Verificar que cada operación registró un evento en la línea de tiempo
          final events = await personnelRepo.listTimelineEvents(empId);
          expect(
            events.any((e) => e.title.contains('datos bancarios')),
            isTrue,
          );
          expect(
            events.any((e) => e.title.contains('seguridad social')),
            isTrue,
          );
          expect(
            events.any((e) => e.title.contains('datos personales')),
            isTrue,
          );
          expect(
            events.any((e) => e.title.contains('datos contractuales')),
            isTrue,
          );
          expect(events.any((e) => e.title.contains('bonificaciones')), isTrue);
          expect(events.any((e) => e.title.contains('deducciones')), isTrue);
          expect(
            events.any((e) => e.title.contains('asignación organizacional')),
            isTrue,
          );
          expect(
            events.any((e) => e.title.contains('checklist documental')),
            isTrue,
          );
        },
      );
    },
  );
}
