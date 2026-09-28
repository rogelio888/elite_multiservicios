import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_hiring_repository.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_applicant_repository.dart';
import 'package:elite_multiservicios_server/src/exceptions/app_exception.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'RRHH Hiring Dossier Integration Tests',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      Session getSession() {
        return (sessionBuilder as dynamic).internalBuild(
              endpoint: 'rrhhHiring',
              method: 'listActiveDossiers',
            )
            as Session;
      }

      Future<RrhhApplicant> createTestApplicant(
        Session session,
        String prefix,
      ) async {
        final applicantRepo = RrhhRecruitmentRepository(session);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        return await applicantRepo.createApplicant(
          RrhhApplicant(
            code: 'AUTO',
            fullName: '$prefix Postulante $timestamp',
            identityCard: '$timestamp LPZ',
            phone: '+591 76543210',
            email: 'postulante.$timestamp@test.com',
            address: 'Av. Las Palmas #500',
            targetType: 'CAMPO',
            targetArea: 'Operaciones',
            targetPosition: 'Técnico de Limpieza',
            specialty: 'Limpieza Industrial',
            education: 'Secundaria',
            experienceSummary: '3 años de experiencia en limpieza industrial.',
            skills: 'Manejo de químicos, pulidoras',
            referencePerson: 'Juan Pérez',
            referencePhone: '+591 71122334',
            applicationDate: DateTime.now().toUtc(),
            status: 'SELECCIONADO',
            hasCvAttached: true,
            hasIdentityCardCopy: true,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }

      test(
        '1. createDossier crea un dossier con datos correctos y código correlativo',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Crear');

          final dossier = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          expect(dossier.id, isNotNull);
          expect(dossier.code, startsWith('DOS-'));
          expect(dossier.applicantId, equals(applicant.id));
          expect(dossier.applicantCode, equals(applicant.code));
          expect(dossier.applicantName, equals(applicant.fullName));
          expect(dossier.status, equals('abierto'));
          expect(dossier.section1Status, equals('pendiente'));
          expect(dossier.section2Status, equals('pendiente'));
          expect(dossier.section3Status, equals('pendiente'));
          expect(dossier.section4Status, equals('pendiente'));
          expect(dossier.section5Status, equals('pendiente'));
          expect(dossier.section6Status, equals('pendiente'));
          expect(dossier.isDeleted, isFalse);
        },
      );

      test(
        '2. createDossier es idempotente y rechaza expedientes duplicados activos para el mismo postulante',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Idempotencia');

          await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          expect(
            () => hiringRepo.createDossier(
              applicantId: applicant.id!,
              createdBy: 'admin_test',
            ),
            throwsA(isA<ConflictException>()),
          );
        },
      );

      test(
        '3. getDossierById retorna el dossier si existe y no está eliminado',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'GetById');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          final fetched = await hiringRepo.getDossierById(created.id!);
          expect(fetched, isNotNull);
          expect(fetched!.id, equals(created.id));
          expect(fetched.code, equals(created.code));
        },
      );

      test('4. getDossierById retorna null si el id no existe', () async {
        final session = getSession();
        final hiringRepo = RrhhHiringRepository(session);
        final fetched = await hiringRepo.getDossierById(999999);
        expect(fetched, isNull);
      });

      test(
        '5. updateDossierSection1 actualiza documentChecklist y sección 1',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Sec1');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          final updated = await hiringRepo.updateDossierSection1(
            id: created.id!,
            documentChecklist: [
              RrhhDossierDocument(
                code: 'CI',
                name: 'Cédula de Identidad',
                isRequired: true,
                status: 'validado',
              ),
              RrhhDossierDocument(
                code: 'CROQUIS',
                name: 'Croquis de Domicilio',
                isRequired: true,
                status: 'validado',
              ),
            ],
            sectionStatus: 'completa',
          );

          expect(updated.section1Status, equals('completa'));
          expect(
            updated.documentChecklist?.any(
              (d) => d.code == 'CI' && d.status == 'validado',
            ),
            isTrue,
          );
          expect(updated.status, equals('en_proceso'));
        },
      );

      test(
        '6. updateDossierSection2 actualiza afiliación de seguridad social',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Sec2');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          final updated = await hiringRepo.updateDossierSection2(
            id: created.id!,
            afpName: 'Gestora Pública',
            afpNumber: '12345678',
            healthInsurance: 'Caja Nacional de Salud',
            notes: 'Documentos de afiliación recepcionados',
            sectionStatus: 'completa',
          );

          expect(updated.section2Status, equals('completa'));
          expect(updated.afpName, equals('Gestora Pública'));
          expect(updated.afpNumber, equals('12345678'));
          expect(updated.healthInsurance, equals('Caja Nacional de Salud'));
        },
      );

      test(
        '7. updateDossierSection3 actualiza datos personales complementarios',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Sec3');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          final updated = await hiringRepo.updateDossierSection3(
            id: created.id!,
            fullAddress: 'Barrio Urbari Calle 2 #45',
            maritalStatus: 'CASADO',
            childrenCount: 2,
            emergencyContactName: 'María Gómez',
            emergencyContactPhone: '+591 78901234',
            emergencyContactRelation: 'Esposa',
            sectionStatus: 'completa',
          );

          expect(updated.section3Status, equals('completa'));
          expect(updated.fullAddress, equals('Barrio Urbari Calle 2 #45'));
          expect(updated.maritalStatus, equals('CASADO'));
          expect(updated.childrenCount, equals(2));
          expect(updated.emergencyContactName, equals('María Gómez'));
        },
      );

      test(
        '8. updateDossierSection4 actualiza condiciones contractuales',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Sec4');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          final now = DateTime.now().toUtc();
          final updated = await hiringRepo.updateDossierSection4(
            id: created.id!,
            contractType: 'INDEFINIDO',
            workdayType: 'TIEMPO_COMPLETO_48H',
            paymentModality: 'MENSUAL',
            baseSalary: 2800.0,
            contractStartDate: now,
            contractEndDate: null,
            bonuses: [
              RrhhEmployeeBonus(
                code: 'BON-001',
                name: 'Bono puntualidad',
                type: 'FIJO',
                amount: 200.0,
              ),
            ],
            deductions: [],
            notes: 'Acuerdo salarial pactado',
            sectionStatus: 'completa',
          );

          expect(updated.section4Status, equals('completa'));
          expect(updated.baseSalary, equals(2800.0));
          expect(updated.bonuses?.first.name, equals('Bono puntualidad'));
        },
      );

      test('9. updateDossierSection5 actualiza asignación operativa', () async {
        final session = getSession();
        final hiringRepo = RrhhHiringRepository(session);
        final applicant = await createTestApplicant(session, 'Sec5');
        final created = await hiringRepo.createDossier(
          applicantId: applicant.id!,
          createdBy: 'admin_test',
        );

        final updated = await hiringRepo.updateDossierSection5(
          id: created.id!,
          areaId: null,
          positionId: null,
          shiftId: 'TURNO_MANANA',
          scheduleId: null,
          baseLocation: 'Parque Industrial - Lote 12',
          supervisorEmployeeId: 'EMP-001',
          effectiveStartDate: DateTime.now().toUtc(),
          notes: 'Asignado a cuadrilla alfa',
          sectionStatus: 'completa',
        );

        expect(updated.section5Status, equals('completa'));
        expect(updated.baseLocation, equals('Parque Industrial - Lote 12'));
        expect(updated.supervisorEmployeeId, equals('EMP-001'));
      });

      test(
        '10. updateDossierSection6 actualiza notas de cierre y aprobación',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Sec6');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          final updated = await hiringRepo.updateDossierSection6(
            id: created.id!,
            closingNotes:
                'Expediente revisado y validado por Dirección de RRHH',
            approvedBy: 'Director RRHH',
            sectionStatus: 'completa',
          );

          expect(updated.section6Status, equals('completa'));
          expect(updated.approvedBy, equals('Director RRHH'));
          expect(updated.approvedAt, isNotNull);
        },
      );

      test(
        '11. convertDossierToEmployee falla si las secciones requeridas no están completas',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Incompleto');
          final created = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          expect(
            () => hiringRepo.convertDossierToEmployee(
              id: created.id!,
              createdBy: 'admin_test',
            ),
            throwsA(isA<ValidationException>()),
          );
        },
      );

      test(
        '12-14. convertDossierToEmployee convierte a empleado, actualiza applicant a CONTRATADO y es idempotente',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicantRepo = RrhhRecruitmentRepository(session);
          final applicant = await createTestApplicant(session, 'Conversion');

          final dossier = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          // Completar las secciones 1 a 5
          await hiringRepo.updateDossierSection1(
            id: dossier.id!,
            documentChecklist: [
              RrhhDossierDocument(
                code: 'CI',
                name: 'Cédula de Identidad',
                isRequired: true,
                status: 'validado',
              ),
            ],
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection2(
            id: dossier.id!,
            afpName: 'Gestora',
            afpNumber: '998877',
            healthInsurance: 'CNS',
            notes: null,
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection3(
            id: dossier.id!,
            fullAddress: 'Av. Brasil #123',
            maritalStatus: 'SOLTERO',
            childrenCount: 0,
            emergencyContactName: 'Pedro Pérez',
            emergencyContactPhone: '+591 70000000',
            emergencyContactRelation: 'Hermano',
            sectionStatus: 'completa',
          );
          await hiringRepo.updateDossierSection4(
            id: dossier.id!,
            contractType: 'PLAZO_FIJO',
            workdayType: 'TIEMPO_COMPLETO_48H',
            paymentModality: 'MENSUAL',
            baseSalary: 3200.0,
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
            shiftId: 'TURNO_A',
            scheduleId: null,
            baseLocation: 'Sede Norte',
            supervisorEmployeeId: 'EMP-001',
            effectiveStartDate: DateTime.now().toUtc(),
            notes: null,
            sectionStatus: 'completa',
          );

          // Convertir a empleado
          final employee = await hiringRepo.convertDossierToEmployee(
            id: dossier.id!,
            createdBy: 'admin_test',
          );

          // 12. Verificar creación de Empleado
          expect(employee.id, isNotNull);
          expect(employee.code, startsWith('EMP-'));
          expect(employee.fullName, equals(applicant.fullName));
          expect(employee.afpName, equals('Gestora'));
          expect(employee.healthInsurance, equals('CNS'));
          expect(employee.fullAddress, equals('Av. Brasil #123'));
          expect(employee.baseLocation, equals('Sede Norte'));
          // agreedSalary se enmascara si la sesión no tiene permiso rrhh.compensation.view
          expect(employee.agreedSalary, isNull);
          expect(employee.status, equals('ACTIVO'));

          // 13. Verificar que applicant pasó a 'CONTRATADO'
          final updatedApplicant = await applicantRepo.getApplicantById(
            applicant.id!,
          );
          expect(updatedApplicant?.status, equals('CONTRATADO'));

          // Verificar que dossier pasó a 'convertido'
          final convertedDossier = await hiringRepo.getDossierById(dossier.id!);
          expect(convertedDossier?.status, equals('convertido'));
          expect(convertedDossier?.employeeId, equals(employee.id));
          expect(
            convertedDossier?.convertedEmployeeCode,
            equals(employee.code),
          );
          expect(convertedDossier?.section6Status, equals('completa'));

          // 14. Idempotencia: intentar reconvertir debe fallar con ConflictException
          expect(
            () => hiringRepo.convertDossierToEmployee(
              id: dossier.id!,
              createdBy: 'admin_test',
            ),
            throwsA(isA<ConflictException>()),
          );
        },
      );

      test(
        '15. deleteDossier aplica soft-delete sobre expedientes abiertos o pausados',
        () async {
          final session = getSession();
          final hiringRepo = RrhhHiringRepository(session);
          final applicant = await createTestApplicant(session, 'Delete');

          final dossier = await hiringRepo.createDossier(
            applicantId: applicant.id!,
            createdBy: 'admin_test',
          );

          await hiringRepo.deleteDossier(dossier.id!);

          final deleted = await hiringRepo.getDossierById(dossier.id!);
          expect(deleted, isNull);
        },
      );
    },
  );
}
