import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/models/rrhh_applicant_summary_dto.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_recruitment_kanban.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_recruitment_kanban_card.dart';

void main() {
  group('RrhhRecruitmentKanban Drag and Drop Tests', () {
    late List<RrhhApplicantSummaryDto> testApplicants;

    setUp(() {
      testApplicants = [
        RrhhApplicantSummaryDto(
          id: 1,
          code: 'POST-001',
          fullName: 'Carlos Sanchez',
          targetType: 'CAMPO',
          targetPosition: 'Operario de Limpieza',
          specialty: 'Industrial',
          status: 'NUEVO',
          applicationDate: DateTime(2026, 9, 20),
          hasCv: true,
        ),
      ];
    });

    testWidgets('renders kanban and card in correct initial column', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RrhhRecruitmentKanban(
              applicants: testApplicants,
              onCardTap: (_) {},
              onApplicantDropped: (_, _) {},
            ),
          ),
        ),
      );

      // Tarjeta visible
      expect(find.text('Carlos Sanchez'), findsOneWidget);
      expect(find.text('POST-001'), findsOneWidget);
      // Columna 1. Nuevos debe tener contador 1
      expect(find.text('1. Nuevos'), findsOneWidget);
    });

    testWidgets('allows valid drag from NUEVO to EN_REVISION', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      RrhhApplicantSummaryDto? droppedApplicant;
      String? droppedTargetStage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RrhhRecruitmentKanban(
              applicants: testApplicants,
              onCardTap: (_) {},
              onApplicantDropped: (applicant, targetStage) {
                droppedApplicant = applicant;
                droppedTargetStage = targetStage;
              },
            ),
          ),
        ),
      );

      final cardFinder = find.byType(RrhhRecruitmentKanbanCard);
      expect(cardFinder, findsOneWidget);

      final enRevisionColFinder = find.text('2. En Revisión');
      expect(enRevisionColFinder, findsOneWidget);

      // Drag and drop hacia Columna 2
      final gesture = await tester.startGesture(tester.getCenter(cardFinder));
      await tester.pump(const Duration(milliseconds: 100));

      // Mover hacia la columna En Revisión
      await gesture.moveTo(tester.getCenter(enRevisionColFinder) + const Offset(0, 80));
      await tester.pump(const Duration(milliseconds: 100));

      // Soltar
      await gesture.up();
      await tester.pumpAndSettle();

      expect(droppedApplicant?.id, equals(1));
      expect(droppedTargetStage, equals('EN_REVISION'));
    });

    testWidgets('rejects invalid drag from NUEVO to SELECCIONADO', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      RrhhApplicantSummaryDto? droppedApplicant;
      String? droppedTargetStage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RrhhRecruitmentKanban(
              applicants: testApplicants,
              onCardTap: (_) {},
              onApplicantDropped: (applicant, targetStage) {
                droppedApplicant = applicant;
                droppedTargetStage = targetStage;
              },
            ),
          ),
        ),
      );

      final cardFinder = find.byType(RrhhRecruitmentKanbanCard);
      final seleccionadosColFinder = find.text('5. Seleccionados');

      // Drag and drop hacia Seleccionados (transición ilegal)
      final gesture = await tester.startGesture(tester.getCenter(cardFinder));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.moveTo(tester.getCenter(seleccionadosColFinder) + const Offset(0, 80));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.up();
      await tester.pumpAndSettle();

      // No debe ser aceptado
      expect(droppedApplicant, isNull);
      expect(droppedTargetStage, isNull);
    });

    testWidgets('allows backward drag from EN_REVISION to NUEVO for error correction', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final applicantInRevision = [
        RrhhApplicantSummaryDto(
          id: 2,
          code: 'POST-002',
          fullName: 'Carlos Gómez',
          targetType: 'OFICINA',
          targetPosition: 'Analista Contable',
          specialty: 'Contabilidad General',
          applicationDate: DateTime(2026, 9, 20),
          hasCv: true,
          status: 'EN_REVISION',
        ),
      ];

      RrhhApplicantSummaryDto? droppedApplicant;
      String? droppedTargetStage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RrhhRecruitmentKanban(
              applicants: applicantInRevision,
              onCardTap: (_) {},
              onApplicantDropped: (applicant, targetStage) {
                droppedApplicant = applicant;
                droppedTargetStage = targetStage;
              },
            ),
          ),
        ),
      );

      final cardFinder = find.byType(RrhhRecruitmentKanbanCard);
      final nuevosColFinder = find.text('1. Nuevos');

      // Drag and drop hacia columna 1. Nuevos (retroceso permitido)
      final gesture = await tester.startGesture(tester.getCenter(cardFinder));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.moveTo(tester.getCenter(nuevosColFinder) + const Offset(0, 80));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(droppedApplicant?.id, equals(2));
      expect(droppedTargetStage, equals('NUEVO'));
    });
  });
}
