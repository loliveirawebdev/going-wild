import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/ui/phase_selection/phase_cover.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_card.dart';

void main() {
  test('every phase has its cover next to its content', () {
    for (final phase in allPhases) {
      expect(File(phaseCoverAssetPathOf(phase)).existsSync(), isTrue, reason: phase.id.value);
    }
  });

  testWidgets('the card shows its number, its name and its details, and a tap reaches the action', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PhaseCard(
              name: 'Quintal',
              numberLabel: 'Fase 1',
              onPressed: () => tapCount++,
              coverAssetPath: phaseCoverAssetPathOf(backyard),
              details: const [PhaseCardDetail(label: 'Rodadas', value: '10')],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Fase 1'), findsOneWidget);
    expect(find.text('Quintal'), findsOneWidget);
    expect(find.text('RODADAS'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(tester.getSize(find.byType(PhaseCard)).width, 250);

    await tester.tap(find.text('Quintal'));
    expect(tapCount, 1);
  });

  testWidgets('holding the card sinks it onto its bottom edge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PhaseCard(
              name: 'Quintal',
              onPressed: () {},
              numberLabel: 'Fase 1',
              coverAssetPath: phaseCoverAssetPathOf(backyard),
              details: const [PhaseCardDetail(label: 'Rodadas', value: '10')],
            ),
          ),
        ),
      ),
    );

    Container frameOf() => tester
        .widgetList<Container>(find.descendant(of: find.byType(PhaseCard), matching: find.byType(Container)))
        .firstWhere((container) => container.transform != null);

    final gesture = await tester.startGesture(tester.getCenter(find.text('Quintal')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(frameOf().transform!.getTranslation().y, 7);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(frameOf().transform!.getTranslation().y, 0);
  });
}
