import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_applicant_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'RRHH Recruitment & Applicant Pipeline Tests',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      test(
        'Flujo completo de Postulantes: Registro, Generación de Código, Compuertas de Estado y Soft Delete',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rrhhApplicant',
                    method: 'listApplicants',
                  )
                  as Session;

          final repo = RrhhRecruitmentRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // ===================================================================
          // 1. REGISTRO Y AUTO-GENERACIÓN DE CÓDIGO
          // ===================================================================
          final applicant = await repo.createApplicant(
            RrhhApplicant(
              code: 'AUTO',
              fullName: 'Postulante Prueba $timestamp',
              identityCard: '$timestamp SCZ',
              phone: '+591 70000000',
              email: 'test.$timestamp@postulante.com',
              address: 'Av. Las Américas #100',
              targetType: 'CAMPO',
              targetArea: 'Operaciones',
              targetPosition: 'Jardinero',
              specialty: 'Jardinería & Paisajismo',
              education: 'Bachiller',
              experienceSummary:
                  'Experiencia previa comprobable en podado y jardines.',
              skills: 'Uso de desbrozadora, riego tecnificado',
              referencePerson: 'Carlos Vaca',
              referencePhone: '+591 71111111',
              applicationDate: DateTime.now().toUtc(),
              status: 'NUEVO',
              hasCvAttached: true,
              hasIdentityCardCopy: true,
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          expect(applicant.id, isNotNull);
          expect(applicant.code, startsWith('POST-'));
          expect(applicant.status, equals('NUEVO'));
          expect(applicant.isDeleted, isFalse);

          // ===================================================================
          // 2. BÚSQUEDA Y FILTRADO POR ESTADO
          // ===================================================================
          final foundList = await repo.listApplicants(
            status: 'NUEVO',
            search: applicant.fullName,
          );
          expect(foundList.any((a) => a.id == applicant.id), isTrue);

          // ===================================================================
          // 3. COMPUERTAS DE EVALUACIÓN Y ENTREVISTA
          // ===================================================================
          // Paso a Evaluación
          final inEval = await repo.updateApplicantStatus(
            applicant.id!,
            newStatus: 'EN_EVALUACION',
            interviewNotes: 'Primera entrevista telefónica satisfactoria.',
          );
          expect(inEval.status, equals('EN_EVALUACION'));
          expect(inEval.interviewNotes, contains('satisfactoria'));

          // Paso a Seleccionado
          final selected = await repo.updateApplicantStatus(
            applicant.id!,
            newStatus: 'SELECCIONADO',
            interviewNotes:
                'Entrevista presencial aprobada. Listo para propuesta y contratación.',
          );
          expect(selected.status, equals('SELECCIONADO'));

          // Rechazo de estados inválidos
          expect(
            () => repo.updateApplicantStatus(
              applicant.id!,
              newStatus: 'ESTADO_INEXISTENTE',
            ),
            throwsA(isA<FormatException>()),
          );

          // ===================================================================
          // 4. SOFT DELETE DEL POSTULANTE
          // ===================================================================
          final deleted = await repo.deleteApplicant(applicant.id!);
          expect(deleted, isTrue);

          // Verificar que no aparezca en listado normal
          final afterDelete = await repo.listApplicants(
            search: applicant.fullName,
          );
          expect(afterDelete.any((a) => a.id == applicant.id), isFalse);

          // Verificar que se conserve en auditoría
          final inDb = await repo.getApplicantById(
            applicant.id!,
            includeDeleted: true,
          );
          expect(inDb!.isDeleted, isTrue);
          expect(inDb.deletedAt, isNotNull);
        },
      );
    },
  );
}
