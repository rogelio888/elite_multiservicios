import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_hiring_dossier.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_mock_dataset.dart';

void main() {
  group('FASE C1: Modelo RrhhHiringDossier & RrhhDossierDocument', () {
    test('Checklist dinámico para CAMPO hace obligatorio FELCC y no aplica TÍTULO', () {
      final checklist = RrhhDossierDocument.defaultChecklistFor(
        workplaceType: 'CAMPO',
        targetPosition: 'Técnico de Limpieza',
      );

      expect(checklist.containsKey('CI'), isTrue);
      expect(checklist['CI']!.isRequired, isTrue);
      expect(checklist['CI']!.requirementType, 'obligatorio');

      expect(checklist.containsKey('FELCC'), isTrue);
      expect(checklist['FELCC']!.isRequired, isTrue);
      expect(checklist['FELCC']!.requirementType, 'obligatorio');

      expect(checklist.containsKey('TITULO'), isTrue);
      expect(checklist['TITULO']!.isRequired, isFalse);
      expect(checklist['TITULO']!.requirementType, 'no_aplica');

      expect(checklist.containsKey('LICENCIA'), isTrue);
      expect(checklist['LICENCIA']!.requirementType, 'no_aplica');

      // Si el cargo requiere conducir:
      final driverChecklist = RrhhDossierDocument.defaultChecklistFor(
        workplaceType: 'CAMPO',
        targetPosition: 'Chofer de Cuadrilla',
      );
      expect(driverChecklist['LICENCIA']!.requirementType, 'condicional');
    });

    test('Checklist dinámico para OFICINA (Seguridad) hace condicional FELCC', () {
      final checklist = RrhhDossierDocument.defaultChecklistFor(
        workplaceType: 'OFICINA',
        targetPosition: 'Guardia de Seguridad Central',
      );

      expect(checklist['FELCC']!.requirementType, 'condicional');
      expect(checklist['FELCC']!.isRequired, isFalse);
    });

    test('Checklist dinámico para OFICINA regular (Contador) hace condicional TÍTULO', () {
      final checklist = RrhhDossierDocument.defaultChecklistFor(
        workplaceType: 'OFICINA',
        targetPosition: 'Contador General',
      );

      expect(checklist['FELCC']!.requirementType, 'no_aplica');
      expect(checklist['TITULO']!.requirementType, 'condicional');
    });

    test('areAllRequiredDocumentsValidated verifica solo los documentos obligatorios', () {
      final checklist = RrhhDossierDocument.defaultChecklistFor(
        workplaceType: 'CAMPO',
        targetPosition: 'Operario',
      );

      var dossier = RrhhHiringDossier(
        id: 1,
        applicantId: 10,
        applicantCode: 'POST-010',
        applicantName: 'Juan Pérez',
        applicantCi: '1234567',
        applicantPhone: '77123456',
        targetArea: 'Operaciones',
        targetPosition: 'Operario',
        workplaceType: 'CAMPO',
        applicationDate: DateTime.now(),
        createdAt: DateTime.now(),
        documents: checklist,
      );

      expect(dossier.areAllRequiredDocumentsValidated, isFalse);
      expect(dossier.dossierStatusLabel, 'Documentos pendientes');

      // Validamos todos los obligatorios (CI, AVISO, CROQUIS, FOTO, SUS, FELCC)
      final updatedDocs = Map<String, RrhhDossierDocument>.from(dossier.documents);
      for (final key in ['CI', 'AVISO', 'CROQUIS', 'FOTO', 'SUS', 'FELCC']) {
        updatedDocs[key] = updatedDocs[key]!.copyWith(status: 'validado');
      }

      dossier = dossier.copyWith(documents: updatedDocs);
      expect(dossier.areAllRequiredDocumentsValidated, isTrue);

      // Si marcamos la sección 1 como completa, el estado pasa a 'En proceso'
      dossier = dossier.copyWith(section1Status: 'completa');
      expect(dossier.completedSectionsCount, 1);
      expect(dossier.progressLabel, '1/6 secciones completas');
      expect(dossier.dossierStatusLabel, 'En proceso');
    });

    test('Serialización y deserialización to/from JSON conserva estructura intacta', () {
      final checklist = RrhhDossierDocument.defaultChecklistFor(
        workplaceType: 'CAMPO',
        targetPosition: 'Operario',
      );

      final original = RrhhHiringDossier(
        id: 99,
        applicantId: 14,
        applicantCode: 'POST-014',
        applicantName: 'Marcos Aguilera',
        applicantCi: '4589201 SC',
        applicantPhone: '77291034',
        targetArea: 'Limpieza',
        targetPosition: 'Técnico de Limpieza',
        workplaceType: 'CAMPO',
        applicationDate: DateTime(2026, 3, 10),
        createdAt: DateTime(2026, 3, 15),
        status: 'abierto',
        section1Status: 'pendiente',
        documents: checklist,
      );

      final json = original.toJson();
      final recovered = RrhhHiringDossier.fromJson(json);

      expect(recovered.id, original.id);
      expect(recovered.applicantCode, original.applicantCode);
      expect(recovered.applicantName, original.applicantName);
      expect(recovered.workplaceType, original.workplaceType);
      expect(recovered.documents.length, original.documents.length);
      expect(recovered.documents['CI']?.isRequired, isTrue);
    });
  });

  group('FASE C1: Repositorio RrhhRepositoryMock con Expedientes', () {
    late RrhhRepository repo;

    setUp(() {
      repo = RrhhRepository.current;
    });

    test('POST-014 (SELECCIONADO) arranca con expediente creado automáticamente', () async {
      final dossiers = await repo.listActiveDossiers();
      final post014Dossier = dossiers.firstWhere((d) => d.applicantCode == 'POST-014');

      expect(post014Dossier.applicantCode, 'POST-014');
      expect(post014Dossier.applicantName, contains('Marcos Aguilera'));
      expect(post014Dossier.status, 'abierto');
      expect(post014Dossier.section1Status, 'pendiente');
      expect(post014Dossier.documents.isNotEmpty, isTrue);
    });

    test('createDossierForApplicant es idempotente (no crea duplicados)', () async {
      final applicants = await repo.listApplicants();
      final selectedApp = applicants.firstWhere((a) => a.code == 'POST-014');

      final existing = await repo.getDossierByApplicantId(selectedApp.id!);
      expect(existing, isNotNull);

      // Si llamamos a crear de nuevo para el mismo postulante:
      final repeated = await repo.createDossierForApplicant(selectedApp.id!);
      expect(repeated.id, existing!.id);

      final list = await repo.listActiveDossiers();
      final matches = list.where((d) => d.applicantId == selectedApp.id).toList();
      expect(matches.length, 1);
    });

    test('updateDossierSection1 persiste cambios de documentos y actualiza section1Status', () async {
      final dossiers = await repo.listActiveDossiers();
      final target = dossiers.first;

      final docs = Map<String, RrhhDossierDocument>.from(target.documents);
      docs['CI'] = docs['CI']!.copyWith(
        status: 'validado',
        notes: 'Documento CI original verificado',
      );

      await repo.updateDossierSection1(
        target.id,
        docs,
      );

      final updated = await repo.getDossierById(target.id);
      expect(updated, isNotNull);
      expect(updated!.documents['CI']!.status, 'validado');
      expect(updated.documents['CI']!.notes, contains('original verificado'));
      expect(updated.section1Status, 'en_proceso');
    });

    test('updateDossierStatus permite pausar y reanudar el expediente', () async {
      final dossiers = await repo.listActiveDossiers();
      final target = dossiers.first;

      await repo.updateDossierStatus(target.id, 'pausado');
      var updated = await repo.getDossierById(target.id);
      expect(updated!.status, 'pausado');
      expect(updated.dossierStatusLabel, 'Pausado');

      await repo.updateDossierStatus(target.id, 'abierto');
      updated = await repo.getDossierById(target.id);
      expect(updated!.status, 'abierto');
    });

    test('FASE C3: updateDossierSection4 persiste condiciones contractuales y bonos', () async {
      final dossiers = await repo.listActiveDossiers();
      final target = dossiers.first;

      await repo.updateDossierSection4(
        target.id,
        contractTypeId: 'CONT-IND',
        contractTypeName: 'Indefinido',
        workdayType: 'Completa',
        paymentModalityId: 'MOD-MEN',
        paymentModalityName: 'Mensual',
        baseSalary: 4500.0,
        currency: 'BOB',
        contractStartDate: DateTime(2026, 10, 1),
        bonuses: [
          RrhhEmployeeBonus(
            code: 'BONO-PUNTUALIDAD',
            name: 'Bono Puntualidad',
            amount: 250.0,
            type: 'MENSUAL',
          ),
        ],
        deductions: [],
        sectionStatus: 'completa',
      );

      final updated = await repo.getDossierById(target.id);
      expect(updated, isNotNull);
      expect(updated!.contractTypeId, 'CONT-IND');
      expect(updated.contractTypeName, 'Indefinido');
      expect(updated.baseSalary, 4500.0);
      expect(updated.currency, 'BOB');
      expect(updated.bonuses?.length, 1);
      expect(updated.section4Status, 'completa');
    });

    test('FASE C3: updateDossierSection5 persiste asignación organizacional y turno', () async {
      final dossiers = await repo.listActiveDossiers();
      final target = dossiers.first;

      await repo.updateDossierSection5(
        target.id,
        areaId: '1',
        areaName: 'Operaciones & Servicios',
        positionId: '1',
        positionName: 'Líder de Cuadrilla',
        shiftId: '1',
        shiftName: 'Turno Mañana (07:00 - 15:00)',
        scheduleId: '1',
        scheduleName: 'Lunes a Viernes',
        baseLocation: 'Oficina Central Santa Cruz',
        supervisorEmployeeId: '1',
        supervisorName: 'Lic. Laura Mendoza (Jefatura RRHH)',
        effectiveStartDate: DateTime(2026, 10, 1),
        sectionStatus: 'completa',
      );

      final updated = await repo.getDossierById(target.id);
      expect(updated, isNotNull);
      expect(updated!.areaId, '1');
      expect(updated.areaName, 'Operaciones & Servicios');
      expect(updated.positionName, 'Líder de Cuadrilla');
      expect(updated.shiftName, 'Turno Mañana (07:00 - 15:00)');
      expect(updated.baseLocation, 'Oficina Central Santa Cruz');
      expect(updated.section5Status, 'completa');
    });

    test('FASE C3: Expediente con secciones 1-5 completas muestra 5/6 y Listo para convertir', () async {
      final dossiers = await repo.listActiveDossiers();
      final post16 = dossiers.firstWhere((d) => d.applicantCode == 'POST-016');

      expect(post16.section1Status, 'completa');
      expect(post16.section2Status, 'completa');
      expect(post16.section3Status, 'completa');
      expect(post16.section4Status, 'completa');
      expect(post16.section5Status, 'completa');
      expect(post16.section6Status, 'pendiente');
      expect(post16.completedSectionsCount, 5);
      expect(post16.progressLabel, '5/6 secciones completas');
      expect(post16.dossierStatusLabel, 'Listo para convertir');
      expect(post16.progressFraction, closeTo(5 / 6, 0.01));
    });
  });
}
