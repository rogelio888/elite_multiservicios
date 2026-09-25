import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/views/rrhh_personal_view.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/views/rrhh_hiring_dossier_detail_view.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('FASE C1: Pruebas de Widgets & UI para Contrataciones en Curso', () {
    testWidgets('RrhhPersonalView muestra 3 pestañas: Directorio, Reclutamiento, Contrataciones en Curso', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const RrhhPersonalView()));
      await tester.pumpAndSettle();

      expect(find.text('Directorio'), findsWidgets);
      expect(find.text('Reclutamiento'), findsWidgets);
      expect(find.text('Contrataciones en Curso'), findsWidgets);
    });

    testWidgets('Tab Contrataciones en Curso lista a POST-014 y permite abrir su expediente', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const RrhhPersonalView(initialTab: 'contrataciones')));
      await tester.pumpAndSettle();

      // Verificar que se visualiza la tabla de contrataciones
      expect(find.text('Contrataciones en Curso'), findsWidgets);
      expect(find.text('POST-014'), findsOneWidget);
      expect(find.text('Marcos Aguilera Soto'), findsOneWidget);
      expect(find.text('Documentos pendientes'), findsWidgets);

      // Clic en Abrir Expediente
      final openButton = find.widgetWithText(FilledButton, 'Abrir');
      expect(openButton, findsWidgets);
      await tester.tap(openButton.first);
      await tester.pumpAndSettle();

      // Ahora debe mostrarse la vista completa del Expediente
      expect(find.text('Expediente de Contratación — Marcos Aguilera Soto'), findsOneWidget);
      expect(find.text('Volver a Contrataciones en Curso'), findsOneWidget);

      // Verificar Mini-resumen
      expect(find.text('8899001 SC'), findsWidgets);

      // Verificar Sección 1 (Recepción de Documentos)
      expect(find.text('1. Recepción de Documentos'), findsOneWidget);
      expect(find.text('Fotocopia de Cédula de Identidad'), findsOneWidget);
      expect(find.text('Certificado FELCC'), findsOneWidget);

      // Verificar Secciones 2-5 funcionales y Sección 6 en FASE C4
      expect(find.text('2. Afiliación a Seguridad Social (AFP y Caja Médica)'), findsOneWidget);
      expect(find.text('3. Datos Personales Complementarios y Contacto de Emergencia'), findsOneWidget);
      expect(find.text('4. Condiciones Contractuales y Modalidad de Pago'), findsOneWidget);
      expect(find.text('5. Asignación Organizacional, Turno y Sede Base'), findsOneWidget);
      expect(find.text('6. Revisión y Cierre del Expediente'), findsOneWidget);

      // Botón volver
      final backButton = find.widgetWithText(OutlinedButton, 'Volver a Contrataciones en Curso');
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Volvió a la lista
      expect(find.text('POST-014'), findsOneWidget);
    });

    testWidgets('RrhhHiringDossierDetailView muestra checklist correcto para CAMPO y permite interactuar', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestableWidget(const RrhhHiringDossierDetailView(dossierId: 1)));
      await tester.pumpAndSettle();

      // Verificar breadcrumb y título
      expect(find.text('Personal'), findsWidgets);
      expect(find.text('Contrataciones en Curso'), findsWidgets);
      expect(find.text('POST-014'), findsWidgets);
      expect(find.text('Expediente de Contratación — Marcos Aguilera Soto'), findsOneWidget);

      // Verificar regla CAMPO: FELCC es obligatorio, TÍTULO no aplica
      expect(find.text('Certificado FELCC'), findsOneWidget);
      expect(find.text('Título profesional'), findsOneWidget);

      // Botón "Marcar sección como completa" está deshabilitado si faltan obligatorios
      final completeSectionButton = find.widgetWithText(FilledButton, 'Marcar sección como completa');
      expect(completeSectionButton, findsWidgets);
      final buttonWidget = tester.widget<FilledButton>(completeSectionButton.first);
      expect(buttonWidget.onPressed, isNull);
    });
  });
}
