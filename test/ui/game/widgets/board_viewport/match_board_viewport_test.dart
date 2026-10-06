import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shelf.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/board_framing.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/scene_top_fill.dart';

import '../match_field/match_field_test.dart';

TransformationController transformationOf(WidgetTester tester) =>
    tester.widget<InteractiveViewer>(find.byType(InteractiveViewer)).transformationController!;

void main() {
  testWidgets('on a tall screen the field sits just above the closed bench and the board does not scroll', (tester) async {
    await showGameScreen(tester);

    final closedBenchTop = tester.getTopLeft(find.byType(BenchShelf)).dy;
    final lowestCellCenter = cellCenterOf(tester, const Position(row: 6, column: 1));
    expect(lowestCellCenter.dy, lessThan(closedBenchTop));
    expect(closedBenchTop - lowestCellCenter.dy, lessThan(120));
    expect(find.byType(SceneTopFill), findsOneWidget);

    final emptySpot = cellCenterOf(tester, const Position(row: 2, column: 2));
    await tester.dragFrom(emptySpot, const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(transformationOf(tester).value, Matrix4.identity());
  });

  testWidgets('on a short screen the field starts above the closed bench and scrolls down to the top', (tester) async {
    await showGameScreen(tester, size: const Size(402, 600));

    final closedBenchTop = tester.getTopLeft(find.byType(BenchShelf)).dy;
    expect(cellCenterOf(tester, const Position(row: 6, column: 1)).dy, lessThan(closedBenchTop));
    expect(find.byType(SceneTopFill), findsNothing);
    expect(transformationOf(tester).value.getTranslation().y, lessThan(0));

    final emptySpot = cellCenterOf(tester, const Position(row: 3, column: 2));
    await tester.dragFrom(emptySpot, const Offset(0, 400));
    await tester.pumpAndSettle();

    expect(transformationOf(tester).value, Matrix4.identity());

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('pinching zooms up to twice and a double tap brings the board back unzoomed', (tester) async {
    await showGameScreen(tester);
    final transformation = transformationOf(tester);
    final framing = transformation.value.clone();
    final emptySpot = cellCenterOf(tester, const Position(row: 2, column: 2));

    final firstFinger = await tester.startGesture(emptySpot - const Offset(40, 0));
    final secondFinger = await tester.startGesture(emptySpot + const Offset(40, 0), pointer: 2);
    for (var step = 1; step <= 10; step++) {
      await firstFinger.moveTo(emptySpot - Offset(40.0 + step * 30, 0));
      await secondFinger.moveTo(emptySpot + Offset(40.0 + step * 30, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await firstFinger.up();
    await secondFinger.up();
    await tester.pumpAndSettle();

    expect(transformation.value.getMaxScaleOnAxis(), greaterThan(1));
    expect(transformation.value.getMaxScaleOnAxis(), lessThanOrEqualTo(maximumBoardZoom));

    await tester.tapAt(emptySpot);
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tapAt(emptySpot);
    await tester.pumpAndSettle();

    expect(transformation.value, framing);

    await tester.pumpWidget(const SizedBox());
  });
}
