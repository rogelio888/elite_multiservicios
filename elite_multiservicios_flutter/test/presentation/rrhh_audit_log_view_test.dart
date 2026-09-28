import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_audit_kpis.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_audit_log_detail_drawer.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_audit_log_event_row.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_audit_log_view.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: SizedBox(
          width: 1366,
          height: 850,
          child: RrhhAuditLogView(),
        ),
      ),
    );
  }

  group(
    'RrhhAuditLogView (Pantalla 14 — Bitácora de Movimientos) Widget Tests',
    () {
      testWidgets(
        'renders view with compact header, 4 KPI cards, filters, and full-width table',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          // 1. Header Compacto
          expect(find.text('Bitácora de Movimientos'), findsOneWidget);
          expect(
            find.text('Registro completo de eventos del módulo RRHH'),
            findsOneWidget,
          );
          expect(find.text('Trazabilidad Inmutable'), findsOneWidget);
          expect(find.text('Exportar bitácora'), findsOneWidget);

          // 2. 4 KPIs de Auditoría
          expect(find.byType(RrhhAuditKpis), findsOneWidget);
          expect(find.text('Eventos del período'), findsOneWidget);
          expect(find.text('Usuarios activos'), findsOneWidget);
          expect(find.text('Categoría más frecuente'), findsOneWidget);
          expect(find.text('Última actividad'), findsOneWidget);

          // 3. Filtros
          expect(find.byType(TextField), findsOneWidget);
          expect(find.text('Todas'), findsWidgets);
          expect(find.text('Todos'), findsWidgets);

          // 4. Encabezados de tabla full-width
          expect(find.text('FECHA + HORA'), findsOneWidget);
          expect(find.text('USUARIO'), findsOneWidget);
          expect(find.text('CATEGORÍA'), findsWidgets);
          expect(find.text('EMPLEADO AFECTADO'), findsOneWidget);
          expect(find.text('DESCRIPCIÓN'), findsOneWidget);
          expect(find.text('CAMBIOS'), findsOneWidget);
          expect(find.text('ACCIONES'), findsOneWidget);

          // 5. Filas de eventos renderizadas
          expect(find.byType(RrhhAuditLogEventRow), findsWidgets);
        },
      );

      testWidgets('opens detail drawer when clicking a row or Detalle action', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1366, 850));
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Abre el drawer haciendo tap en el primer botón 'Detalle'
        final detalleBtn = find.widgetWithText(OutlinedButton, 'Detalle').first;
        await tester.ensureVisible(detalleBtn);
        await tester.tap(detalleBtn);
        await tester.pumpAndSettle();

        // Verifica apertura del drawer
        expect(find.byType(RrhhAuditLogDetailDrawer), findsOneWidget);
        expect(find.text('Detalle del Evento'), findsOneWidget);
        expect(find.text('Registro Inmutable de Auditoría'), findsOneWidget);
        expect(find.text('1. DATOS DEL EVENTO'), findsOneWidget);
        expect(find.text('2. RESPONSABLE DE LA OPERACIÓN'), findsOneWidget);
        expect(find.text('3. COLABORADOR AFECTADO'), findsOneWidget);
        expect(find.text('4. REGISTRO COMPARATIVO DE CAMBIOS'), findsOneWidget);
        expect(find.text('5. DOCUMENTOS Y CONSTANCIAS'), findsOneWidget);
        expect(find.text('6. INTEGRIDAD Y METADATOS TÉCNICOS'), findsOneWidget);

        // Cierra el drawer con el botón cerrar (X)
        final closeBtn = find.byTooltip('Cerrar detalle');
        expect(closeBtn, findsOneWidget);
        await tester.tap(closeBtn);
        await tester.pumpAndSettle();

        expect(find.byType(RrhhAuditLogDetailDrawer), findsNothing);
      });

      testWidgets(
        'opens export confirmation dialog when clicking exportar bitacora',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1366, 850));
          await tester.pumpWidget(buildTestWidget());
          await tester.pumpAndSettle();

          final exportBtn = find.text('Exportar bitácora');
          await tester.tap(exportBtn);
          await tester.pumpAndSettle();

          expect(find.text('Bitácora de Auditoría Exportada'), findsOneWidget);
          expect(find.text('Descargar Archivo'), findsOneWidget);

          // Cierra diálogo
          await tester.tap(find.text('Cerrar'));
          await tester.pumpAndSettle();
          expect(find.text('Bitácora de Auditoría Exportada'), findsNothing);
        },
      );
    },
  );
}
