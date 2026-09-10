import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/shared/widgets/app_card.dart';
import 'package:elite_multiservicios_flutter/core/theme/app_theme.dart';

void main() {
  testWidgets('AppCard renders child and responds to tap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: AppCard(
            onTap: () => tapped = true,
            child: const Text('Elite Multiservicios Card'),
          ),
        ),
      ),
    );

    expect(find.text('Elite Multiservicios Card'), findsOneWidget);

    await tester.tap(find.byType(AppCard));
    expect(tapped, isTrue);
  });
}
