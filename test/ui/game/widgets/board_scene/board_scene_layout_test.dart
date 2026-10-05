import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

void main() {
  final board = backyard.engines.combatEngine.board;

  test('every row of the backyard board has one painted cell per board cell', () {
    for (var row = 0; row < board.rows.length; row++) {
      final cellCount = board.allPositions.where((position) => position.row == row).length;
      expect(BoardSceneLayout.rowCenterWidths[row], hasLength(cellCount), reason: 'row $row');
    }

    expect(BoardSceneLayout.rowCenterHeights, hasLength(board.rows.length));
  });

  test('the cells keep their place in the painting at any screen width', () {
    for (final width in [360.0, 402.0, 430.0]) {
      final scale = BoardSceneLayout.scaleFor(width);

      for (final position in board.allPositions) {
        final cellRect = BoardSceneLayout.cellRectOf(board, position, scale: scale);
        final originalRect = BoardSceneLayout.cellRectOf(board, position, scale: 1);

        expect(cellRect.center.dx / width, closeTo(originalRect.center.dx / BoardSceneLayout.imageSize.width, 0.0001));
        expect(cellRect.width / width, closeTo(BoardSceneLayout.cellSize.width / BoardSceneLayout.imageSize.width, 0.0001));
      }
    }
  });

  test('the first cell of the second row is the one next to the blocked corner', () {
    final firstCellOfSecondRow = board.allPositions.firstWhere((position) => position.row == 1);
    final cellRect = BoardSceneLayout.cellRectOf(board, firstCellOfSecondRow, scale: 1);

    expect(firstCellOfSecondRow.column, 1);
    expect(cellRect.center, const Offset(242, 462));
  });

  testWidgets('the scene takes the whole width and keeps the painting proportions even on a shorter screen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [Positioned(top: 0, left: 0, right: 0, child: BoardScene())],
          ),
        ),
      ),
    );

    final sceneSize = tester.getSize(find.byType(BoardScene));
    expect(sceneSize.width, 800);
    expect(sceneSize.height, closeTo(800 * 1376 / 768, 0.01));
  });
}
