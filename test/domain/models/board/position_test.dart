import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/board/position.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('distance is the king move count: diagonal costs one', () {
    expect(at(0, 0).distanceToPosition(at(0, 0)), 0);
    expect(at(0, 0).distanceToPosition(at(1, 1)), 1);
    expect(at(0, 0).distanceToPosition(at(3, 1)), 3);
    expect(at(2, 4).distanceToPosition(at(0, 0)), 4);
  });

  test('board knows its bounds', () {
    expect(testBoard.isPositionWithinBounds(at(0, 0)), isTrue);
    expect(testBoard.isPositionWithinBounds(at(7, 4)), isTrue);
    expect(testBoard.isPositionWithinBounds(at(8, 0)), isFalse);
    expect(testBoard.isPositionWithinBounds(at(0, 5)), isFalse);
    expect(testBoard.isPositionWithinBounds(at(-1, 0)), isFalse);
  });

  test('neighbors include diagonals and stop at the edge', () {
    expect(testBoard.neighborPositionsAround(at(3, 2)).length, 8);
    expect(testBoard.neighborPositionsAround(at(0, 2)).length, 5);
    expect(testBoard.neighborPositionsAround(at(0, 0)).length, 3);
  });

  test('positions are values', () {
    expect(at(1, 2), const Position(row: 1, column: 2));
    expect({at(1, 2), at(1, 2)}.length, 1);
  });
}
