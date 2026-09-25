import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/repositories/rrhh_repository_mock.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/views/rrhh_organization_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_organization_tab_areas.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_organization_tab_positions.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_organization_tab_specialties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    RrhhRepository.current = RrhhRepositoryMock();
  });

  group('RrhhOrganizationView Tests', () {
    testWidgets('renders organization view with 3 tabs and default Tab 1 Áreas', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RrhhOrganizationView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verificar encabezado ejecutivo
      expect(find.text('Estructura Organizacional'), findsOneWidget);
      expect(find.text('Catálogos maestros de áreas, cargos y especialidades'), findsOneWidget);

      // Verificar las 3 tabs
      expect(find.text('1. Áreas'), findsOneWidget);
      expect(find.text('2. Cargos'), findsOneWidget);
      expect(find.text('3. Especialidades'), findsOneWidget);

      // Tab 1 Áreas está activa por defecto
      expect(find.byType(RrhhOrganizationTabAreas), findsOneWidget);
      expect(find.text('Áreas Departamentales'), findsOneWidget);
      expect(find.text('Nueva Área'), findsOneWidget);
    });

    testWidgets('switches to Tab 2 Cargos and displays positions and area filter', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RrhhOrganizationView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cambiar a Tab 2: Cargos
      await tester.tap(find.text('2. Cargos'));
      await tester.pumpAndSettle();

      expect(find.byType(RrhhOrganizationTabPositions), findsOneWidget);
      expect(find.text('Cargos de Trabajo'), findsOneWidget);
      expect(find.text('Nuevo Cargo'), findsOneWidget);
    });

    testWidgets('switches to Tab 3 Especialidades and displays specialties list', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RrhhOrganizationView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cambiar a Tab 3: Especialidades
      await tester.tap(find.text('3. Especialidades'));
      await tester.pumpAndSettle();

      expect(find.byType(RrhhOrganizationTabSpecialties), findsOneWidget);
      expect(find.text('Especialidades Operativas'), findsOneWidget);
      expect(find.text('Nueva Especialidad'), findsOneWidget);
    });
  });
}
