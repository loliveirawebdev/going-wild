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

  testWidgets('the card shows its number and its name at a fixed width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PhaseCard(name: 'Quintal', numberLabel: 'Fase 1', coverAssetPath: phaseCoverAssetPathOf(backyard)),
          ),
        ),
      ),
    );

    expect(find.text('Fase 1'), findsOneWidget);
    expect(find.text('Quintal'), findsOneWidget);
    expect(tester.getSize(find.byType(PhaseCard)).width, 250);
  });
}
