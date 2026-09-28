import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_catalog_item.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/views/rrhh_catalogs_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('RrhhCatalogsView (Catálogos Auxiliares) Tests', () {
    testWidgets('renders view with header and Bancos catalog by default', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const RrhhCatalogsView()));
      await tester.pumpAndSettle();

      // Verificar Título y Subtítulo de sección
      expect(find.text('Catálogos del Sistema'), findsOneWidget);
      expect(find.text('Listas maestras de RRHH'), findsOneWidget);

      // Verificar items del catálogo de Bancos pre-poblado
      expect(find.text('Banco Unión S.A.'), findsOneWidget);
      expect(find.text('Banco Mercantil Santa Cruz (BMSC)'), findsOneWidget);
      expect(find.text('BANCO-001'), findsOneWidget);

      // Verificar botón nuevo banco
      expect(find.text('Nuevo BANCO'), findsOneWidget);
    });

    testWidgets('allows switching catalog via dropdown', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const RrhhCatalogsView()));
      await tester.pumpAndSettle();

      // Abrir selector de catálogo
      final dropdown = find.byType(DropdownButton<RrhhCatalogType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Seleccionar Bonificaciones
      final bonosOption = find.text('Bonificaciones').last;
      await tester.tap(bonosOption);
      await tester.pumpAndSettle();

      // Verificar columnas y datos de Bonificaciones
      expect(find.text('Nuevo BONO'), findsOneWidget);
      expect(find.text('Bono de Antigüedad'), findsOneWidget);
      expect(find.text('BONO-001'), findsOneWidget);
      expect(find.text('Fija mensual'), findsWidgets);
    });
  });
}
