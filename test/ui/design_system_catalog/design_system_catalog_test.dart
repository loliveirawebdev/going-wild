import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/design_system_catalog/design_system_catalog_app.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_poof.dart';

void main() {
  testWidgets('the catalog lists its sections and opens the tokens with colors, text, shapes and spaces', (tester) async {
    await tester.pumpWidget(const DesignSystemCatalogApp());

    await tester.tap(find.text('Tokens'));
    await tester.pumpAndSettle();

    for (final block in ['Cores', 'Texto', 'Formas', 'Espaços']) {
      await tester.scrollUntilVisible(find.text(block), 300, scrollable: find.byType(Scrollable).last);
      expect(find.text(block), findsOneWidget);
    }
  });

  testWidgets('the catalog shows the round banner, the phase result, the summon poof and the sheet in the fight', (tester) async {
    tester.view.physicalSize = const Size(402, 874) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DesignSystemCatalogApp());

    Future<void> openSection(String title) async {
      await tester.scrollUntilVisible(find.text(title), 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
    }

    Future<void> goBack() async {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    await openSection('RoundBanner');
    await tester.tap(find.text('Vitória com moedas e XP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('+12'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await goBack();

    await openSection('PhaseResult');
    expect(find.text('Fase vencida!'), findsOneWidget);
    await goBack();

    await openSection('SummonPoof');
    await tester.tap(find.text('Tocar o poof'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(SummonPoof), findsNWidgets(2));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SummonPoof), findsNothing);
    await goBack();

    await openSection('UnitSheet');
    await tester.scrollUntilVisible(find.text('Predador caído'), 200, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Predador caído'));
    await tester.pumpAndSettle();
    expect(find.text('Caído'), findsOneWidget);
  });
}
