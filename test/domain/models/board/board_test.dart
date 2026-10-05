import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/board.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('the backyard board has seven rows alternating four and five cells, with one cell left out', () {
    expect(board.rows.map((row) => row.cellCount), [4, 5, 4, 5, 4, 5, 4]);
    expect(board.allPositions, hasLength(30));
    expect(board.isPositionWithinBounds(at(1, 0)), isFalse);
    expect(board.isPositionWithinBounds(at(1, 4)), isTrue);
    expect(board.isPositionWithinBounds(at(0, 4)), isFalse);
    expect(board.isPositionWithinBounds(at(7, 0)), isFalse);
    expect(board.isPositionWithinBounds(at(-1, 0)), isFalse);
  });

  test('the top three rows belong to the enemies, the bottom three to the team and the middle row to both', () {
    expect(board.isPositionOnEnemySide(at(2, 3)), isTrue);
    expect(board.isPositionOnTeamSide(at(2, 3)), isFalse);

    expect(board.isPositionOnEnemySide(at(3, 0)), isTrue);
    expect(board.isPositionOnTeamSide(at(3, 0)), isTrue);

    expect(board.isPositionOnEnemySide(at(4, 0)), isFalse);
    expect(board.isPositionOnTeamSide(at(4, 0)), isTrue);
  });
}
