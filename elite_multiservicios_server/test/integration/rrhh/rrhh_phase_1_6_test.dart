import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_personnel_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_hiring_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_applicant_repository.dart';
import 'package:elite_multiservicios_server/src/authorization/permissions.dart';
import 'package:elite_multiservicios_server/src/exceptions/app_exception.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Fase 1.6: Seguridad y modelo en Backend de Personal (Serverpod)',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      late AppUser testUser;

      setUpAll(() async {
        final setupSession =
            (sessionBuilder as dynamic).internalBuild(
                  endpoint: 'rrhhPersonnel',
                  method: 'getEmployeeById',
                )
                as Session;
        testUser = await AppUser.db.insertRow(
          setupSession,
          AppUser(
            email:
                'admin_test_${DateTime.now().microsecondsSinceEpoch}@elitemultiservicios.com',
            fullName: 'Usuario Admin Test',
            mfaEnabled: false,
            isActive: true,
            isDeleted: false,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      });

      Session getUnauthenticatedSession() {
        return (sessionBuilder as dynamic).internalBuild(
              endpoint: 'rrhhPersonnel',
              method: 'getEmployeeById',
            )
            as Session;
      }

      Session getAuthorizedSession({required Set<String> permissions}) {
        final scopes = permissions.map((p) => Scope(p)).toSet();
        final authorizedBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            testUser.id!.toString(),
            scopes,
            authId: '550e8400-e29b-41d4-a716-446655440099',
          ),
        );
        return (authorizedBuilder as dynamic).internalBuild(
              endpoint: 'rrhhPersonnel',
              method: 'getEmployeeById',
            )
            as Session;
      }

      RrhhEmployee buildTestEmployee({
        required String fullName,
        required String identityCard,
        required String phone,
        String employeeType = 'PLANTA',
        String area = 'Administración',
        String position = 'Contador',
        String specialty = 'General',
        double? agreedSalary = 4000.0,
        List<RrhhEmployeeBonus>? bonuses,
        List<RrhhEmployeeDeduction>? deductions,
        List<RrhhDossierDocument>? documentChecklist,
      }) {
        final now = DateTime.now().toUtc();
        return RrhhEmployee(
          code: 'AUTO',
          fullName: fullName,
          birthPlace: 'Santa Cruz',
          identityCard: identityCard,
          phone: phone,
          address: 'Av. Las Palmas #123',
          occupation: 'Profesional',
          personalReference: 'Juan Pérez',
          referencePhone: '+591 70000000',
          employeeType: employeeType,
          area: area,
          position: position,
          specialty: specialty,
          workplace: 'Oficina Central',
          supervisor: 'Gerente General',
          realStartDate: now,
          fiscalStartDate: now,
          agreedSalary: agreedSalary,
          contractType: 'Indefinido',
          bonuses: bonuses,
          deductions: deductions,
          documentChecklist: documentChecklist,
          status: 'ACTIVO',
          availabilityStatus: 'DISPONIBLE',
          paymentModality: 'MENSUAL',
          workScheduleType: 'TIEMPO_COMPLETO_48H',
          createdAt: now,
          updatedAt: now,
        );
      }

      test('1. Enmascaramiento de salario por permisos (Tarea 1)', () async {
        final unauthSession = getUnauthenticatedSession();
        final authSession = getAuthorizedSession(
          permissions: {AppPermissions.rrhhCompensationView},
        );

        final unauthRepo = RrhhPersonnelRepository(unauthSession);
        final authRepo = RrhhPersonnelRepository(authSession);

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final created = await unauthRepo.createEmployee(
          buildTestEmployee(
            fullName: 'Empleado Salario $timestamp',
            identityCard: '$timestamp LPZ',
            phone: '+591 71234567',
            agreedSalary: 5500.0,
            bonuses: [
              RrhhEmployeeBonus(
                code: 'B1',
                name: 'Bono Puntualidad',
                type: 'FIJO',
                amount: 200,
              ),
            ],
            deductions: [
              RrhhEmployeeDeduction(
                code: 'D1',
                name: 'Descuento',
                type: 'FIJO',
                amount: 50,
              ),
            ],
          ),
        );

        // a. Consulta sin permiso -> salario, bonos y deducciones enmascarados (null)
        final unauthEmp = await unauthRepo.getEmployeeById(created.id!);
        expect(unauthEmp, isNotNull);
        expect(unauthEmp!.agreedSalary, isNull);
        expect(unauthEmp.bonuses, isNull);
        expect(unauthEmp.deductions, isNull);

        // b. Consulta con permiso -> salario real, bonos y deducciones presentes
        final authEmp = await authRepo.getEmployeeById(created.id!);
        expect(authEmp, isNotNull);
        expect(authEmp!.agreedSalary, equals(5500.0));
        expect(authEmp.bonuses, isNotNull);
        expect(authEmp.bonuses!.first.amount, equals(200.0));
        expect(authEmp.deductions, isNotNull);
        expect(authEmp.deductions!.first.amount, equals(50.0));

        // c. getEmployeeContractData sin permiso -> baseSalary null
        final unauthContract = await unauthRepo.getEmployeeContractData(
          created.id!,
        );
        expect(unauthContract.baseSalary, isNull);

        // d. getEmployeeContractData con permiso -> baseSalary 5500
        final authContract = await authRepo.getEmployeeContractData(
          created.id!,
        );
        expect(authContract.baseSalary, equals(5500.0));
      });

      test(
        '2. Validación de fecha efectiva <= 30 días futuros (Tarea 3.1)',
        () async {
          final session = getUnauthenticatedSession();
          final repo = RrhhPersonnelRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          final emp = await repo.createEmployee(
            buildTestEmployee(
              fullName: 'Empleado Fecha $timestamp',
              identityCard: '$timestamp SCZ',
              phone: '+591 79998888',
            ),
          );

          final farFutureDate = DateTime.now().toUtc().add(
            const Duration(days: 35),
          );

          // Fecha a 35 días en el futuro debe fallar con ValidationException
          expect(
            () => repo.updateEmployeeContract(
              id: emp.id!,
              contractType: 'PLAZO_FIJO',
              workdayType: 'TIEMPO_COMPLETO_48H',
              paymentModality: 'MENSUAL',
              baseSalary: 4500.0,
              contractStartDate: farFutureDate,
              justification:
                  'Cambio contractual planificado con antelación superior a un mes',
            ),
            throwsA(
              isA<ValidationException>().having(
                (e) => e.message,
                'message',
                contains('no puede superar los 30 días'),
              ),
            ),
          );

          // Fecha dentro de los 30 días debe proceder
          final validFutureDate = DateTime.now().toUtc().add(
            const Duration(days: 15),
          );
          final updated = await repo.updateEmployeeContract(
            id: emp.id!,
            contractType: 'PLAZO_FIJO',
            workdayType: 'TIEMPO_COMPLETO_48H',
            paymentModality: 'MENSUAL',
            baseSalary: 4500.0,
            contractStartDate: validFutureDate,
            justification:
                'Modificación de contrato autorizada por Gerencia de RRHH',
          );
          expect(updated.contractType, equals('PLAZO_FIJO'));
        },
      );

      test(
        '3. Validación de justificación >= 20 caracteres (Tarea 3.2)',
        () async {
          final session = getUnauthenticatedSession();
          final repo = RrhhPersonnelRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          final emp = await repo.createEmployee(
            buildTestEmployee(
              fullName: 'Empleado Justificacion $timestamp',
              identityCard: '$timestamp CBBA',
              phone: '+591 78887777',
            ),
          );

          // Justificación corta (< 20 caracteres) debe fallar con ValidationException
          expect(
            () => repo.updateEmployeeContract(
              id: emp.id!,
              contractType: 'INDEFINIDO',
              workdayType: 'TIEMPO_COMPLETO_48H',
              paymentModality: 'MENSUAL',
              baseSalary: 3800.0,
              contractStartDate: DateTime.now().toUtc(),
              justification: 'Aumento sueldo', // 14 caracteres
            ),
            throwsA(
              isA<ValidationException>().having(
                (e) => e.message,
                'message',
                contains('al menos 20 caracteres'),
              ),
            ),
          );
        },
      );

      test(
        '4. Validación de Certificado FELCC obligatorio para seguridad (Tarea 3.3)',
        () async {
          final session = getUnauthenticatedSession();
          final personnelRepo = RrhhPersonnelRepository(session);
          final applicantRepo = RrhhRecruitmentRepository(session);
          final hiringRepo = RrhhHiringRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // a. createEmployee para personal de seguridad sin FELCC validado debe ser rechazado
          expect(
            () => personnelRepo.createEmployee(
              buildTestEmployee(
                fullName: 'Guardia Sin FELCC $timestamp',
                identityCard: '$timestamp ORU',
                phone: '+591 76665555',
                employeeType: 'CAMPO',
                area: 'Seguridad Física',
                position: 'Guardia de Seguridad',
                specialty: 'Custodia',
                documentChecklist: [
                  RrhhDossierDocument(
                    code: 'CI',
                    name: 'CI',
                    isRequired: true,
                    status: 'validado',
                  ),
                  // FELCC pendiente o ausente
                  RrhhDossierDocument(
                    code: 'FELCC',
                    name: 'Certificado FELCC',
                    isRequired: true,
                    status: 'pendiente',
                  ),
                ],
              ),
            ),
            throwsA(
              isA<ValidationException>().having(
                (e) => e.message,
                'message',
                contains('FELCC es obligatorio para cargos de seguridad'),
              ),
            ),
          );

          // b. createEmployee con FELCC validado debe crearse con éxito
          final secEmp = await personnelRepo.createEmployee(
            buildTestEmployee(
              fullName: 'Guardia Con FELCC $timestamp',
              identityCard: '$timestamp POT',
              phone: '+591 76664444',
              employeeType: 'CAMPO',
              area: 'Seguridad Física',
              position: 'Guardia de Seguridad',
              specialty: 'Custodia',
              documentChecklist: [
                RrhhDossierDocument(
                  code: 'CI',
                  name: 'CI',
                  isRequired: true,
                  status: 'validado',
                ),
                RrhhDossierDocument(
                  code: 'FELCC',
                  name: 'Certificado FELCC',
                  isRequired: true,
                  status: 'validado',
                ),
              ],
            ),
          );
          expect(secEmp.id, isNotNull);

          // c. convertDossierToEmployee para cargo de seguridad sin FELCC validado debe ser rechazado
          final applicant = await applicantRepo.createApplicant(
            RrhhApplicant(
              code: 'AUTO',
              fullName: 'Postulante Vigilante $timestamp',
              identityCard: '$timestamp BEN',
              phone: '+591 75554444',
              targetType: 'CAMPO',
              targetArea: 'Seguridad',
              targetPosition: 'Vigilante Nocturno',
              education: 'Secundaria',
              applicationDate: DateTime.now().toUtc(),
              status: 'SELECCIONADO',
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          final dossier = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          // Solo validamos CI, no FELCC
          await hiringRepo.updateDossierSection1(
            id: dossier.id!,
            documentChecklist: [
              RrhhDossierDocument(
                code: 'CI',
                name: 'CI',
                isRequired: true,
                status: 'validado',
              ),
              RrhhDossierDocument(
                code: 'FELCC',
                name: 'Certificado FELCC',
                isRequired: true,
                status: 'pendiente',
              ),
            ],
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection2(
            id: dossier.id!,
            afpName: 'Gestora',
            afpNumber: '123456',
            healthInsurance: 'CNS',
            notes: null,
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection3(
            id: dossier.id!,
            fullAddress: 'Calle 1',
            maritalStatus: 'SOLTERO',
            childrenCount: 0,
            emergencyContactName: 'Pedro',
            emergencyContactPhone: '+591 7000',
            emergencyContactRelation: 'Hermano',
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection4(
            id: dossier.id!,
            contractType: 'PLAZO_FIJO',
            workdayType: 'ROTATIVO',
            paymentModality: 'MENSUAL',
            baseSalary: 3500.0,
            contractStartDate: DateTime.now().toUtc(),
            contractEndDate: null,
            bonuses: [],
            deductions: [],
            notes: null,
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection5(
            id: dossier.id!,
            areaId: null,
            positionId: null,
            shiftId: null,
            scheduleId: null,
            baseLocation: 'Planta',
            supervisorEmployeeId: null,
            effectiveStartDate: DateTime.now().toUtc(),
            notes: null,
            sectionStatus: 'completa',
          );

          expect(
            () => hiringRepo.convertDossierToEmployee(
              id: dossier.id!,
              createdBy: 'admin_test',
            ),
            throwsA(
              isA<ValidationException>().having(
                (e) => e.message,
                'message',
                contains('FELCC es obligatorio para cargos de seguridad'),
              ),
            ),
          );

          // Si se valida el documento FELCC en sección 1, la conversión debe tener éxito
          await hiringRepo.updateDossierSection1(
            id: dossier.id!,
            documentChecklist: [
              RrhhDossierDocument(
                code: 'CI',
                name: 'CI',
                isRequired: true,
                status: 'validado',
              ),
              RrhhDossierDocument(
                code: 'FELCC',
                name: 'Certificado FELCC',
                isRequired: true,
                status: 'validado',
              ),
            ],
            sectionStatus: 'completa',
          );

          final converted = await hiringRepo.convertDossierToEmployee(
            id: dossier.id!,
            createdBy: 'admin_test',
          );
          expect(converted.id, isNotNull);
          expect(converted.fullName, equals(applicant.fullName));
        },
      );

      test(
        '5. Endpoint optimizado listEmployeeSummaries y countEmployees (Tarea 4)',
        () async {
          final session = getUnauthenticatedSession();
          final repo = RrhhPersonnelRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // Crear 3 empleados de prueba
          for (var i = 1; i <= 3; i++) {
            await repo.createEmployee(
              buildTestEmployee(
                fullName: 'Paginacion Test $timestamp $i',
                identityCard: '$timestamp$i LPZ',
                phone: '+591 7000$i',
                area: 'Tecnología',
                position: 'Desarrollador $i',
                agreedSalary: 6000.0,
              ),
            );
          }

          // a. countEmployees con búsqueda específica
          final count = await repo.countEmployees(
            search: 'Paginacion Test $timestamp',
          );
          expect(count, equals(3));

          // b. listEmployeeSummaries con paginación
          final page1 = await repo.listEmployeeSummaries(
            search: 'Paginacion Test $timestamp',
            limit: 2,
            offset: 0,
          );
          expect(page1.length, equals(2));
          expect(page1.first.fullName, contains('Paginacion Test $timestamp'));

          final page2 = await repo.listEmployeeSummaries(
            search: 'Paginacion Test $timestamp',
            limit: 2,
            offset: 2,
          );
          expect(page2.length, equals(1));

          // c. Verificar que RrhhEmployeeSummaryDto no expone salario ni datos bancarios
          final summary = page1.first;
          expect(summary.id, isNotNull);
          expect(summary.code, startsWith('EMP-'));
          expect(summary.fullName, isNotEmpty);
          expect(summary.status, equals('ACTIVO'));
        },
      );
    },
  );
}
