import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/modules/rrhh/repositories/rrhh_organization_repository.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'RRHH Organization Structure & Catalog Tests',
    testGroupTagsOverride: ['db-integration'],
    (sessionBuilder, endpoints) {
      test(
        'Flujo completo de Áreas, Cargos y Especialidades con validaciones de unicidad y soft delete',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rrhhOrganization',
                    method: 'listAreas',
                  )
                  as Session;

          final repo = RrhhOrganizationRepository(session);
          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // ===================================================================
          // 1. ÁREAS ORGANIZACIONALES
          // ===================================================================
          final areaCode = 'AREA-T-$timestamp';
          final areaName = 'Operaciones Especiales $timestamp';

          final createdArea = await repo.createArea(
            RrhhArea(
              code: areaCode,
              name: areaName,
              description: 'Área de pruebas automatizadas',
              colorTag: '#6366F1',
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          expect(createdArea.id, isNotNull);
          expect(createdArea.code, equals(areaCode));
          expect(createdArea.name, equals(areaName));
          expect(createdArea.isActive, isTrue);
          expect(createdArea.isDeleted, isFalse);

          // Unicidad de código
          expect(
            () => repo.createArea(
              RrhhArea(
                code: areaCode,
                name: 'Otro Nombre',
                createdAt: DateTime.now().toUtc(),
                updatedAt: DateTime.now().toUtc(),
              ),
            ),
            throwsA(isA<FormatException>()),
          );

          // Listado y filtro de búsqueda
          final areasFound = await repo.listAreas(search: areaName);
          expect(areasFound.any((a) => a.id == createdArea.id), isTrue);

          // Actualización de área
          final updatedArea = await repo.updateArea(
            createdArea.copyWith(
              name: '$areaName (Actualizada)',
              colorTag: '#10B981',
            ),
          );
          expect(updatedArea.name, contains('(Actualizada)'));

          // ===================================================================
          // 2. CARGOS / PUESTOS DE TRABAJO
          // ===================================================================
          final posCode = 'CARGO-T-$timestamp';
          final posName = 'Operario Técnico $timestamp';

          final createdPos = await repo.createPosition(
            RrhhPosition(
              code: posCode,
              areaId: createdArea.id!,
              name: posName,
              workplaceType: 'Campo',
              suggestedSalary: 3200.0,
              description: 'Cargo para pruebas',
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          expect(createdPos.id, isNotNull);
          expect(createdPos.code, equals(posCode));
          expect(createdPos.workplaceType, equals('Campo'));

          // Filtro por área y entorno
          final posInArea = await repo.listPositions(
            areaId: createdArea.id!,
            workplaceType: 'Campo',
          );
          expect(posInArea.any((p) => p.id == createdPos.id), isTrue);

          // ===================================================================
          // 3. ESPECIALIDADES TÉCNICAS
          // ===================================================================
          final specCode = 'ESP-T-$timestamp';
          final specName = 'Mantenimiento Crítico $timestamp';

          final createdSpec = await repo.createSpecialty(
            RrhhSpecialty(
              code: specCode,
              name: specName,
              description: 'Especialidad para pruebas',
              colorTag: '#EC4899',
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          );

          expect(createdSpec.id, isNotNull);
          expect(createdSpec.code, equals(specCode));

          final specFound = await repo.listSpecialties(search: specName);
          expect(specFound.any((s) => s.id == createdSpec.id), isTrue);

          // ===================================================================
          // 4. SOFT DELETE Y CASCADA LÓGICA
          // ===================================================================
          final deletedArea = await repo.deleteArea(createdArea.id!);
          expect(deletedArea, isTrue);

          // Verificar que el área no aparezca en listado normal
          final activeAreas = await repo.listAreas(search: areaName);
          expect(activeAreas.any((a) => a.id == createdArea.id), isFalse);

          // Verificar cascada lógica sobre el cargo
          final posAfterDelete = await repo.getPositionById(
            createdPos.id!,
            includeDeleted: true,
          );
          expect(posAfterDelete!.isDeleted, isTrue);
          expect(posAfterDelete.isActive, isFalse);

          // Soft delete de especialidad
          final deletedSpec = await repo.deleteSpecialty(createdSpec.id!);
          expect(deletedSpec, isTrue);
        },
      );
    },
  );
}
