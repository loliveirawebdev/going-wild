import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/board/position.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('distance counts hexagon steps, and the row below a half-shifted row touches two cells', () {
    expect(at(0, 0).distanceToPosition(at(0, 0)), 0);
    expect(at(0, 0).distanceToPosition(at(1, 0)), 1);
    expect(at(0, 0).distanceToPosition(at(1, 1)), 1);
    expect(at(0, 0).distanceToPosition(at(0, 3)), 3);
    expect(at(0, 0).distanceToPosition(at(2, 0)), 2);
    expect(at(0, 0).distanceToPosition(at(4, 0)), 4);
    expect(at(3, 4).distanceToPosition(at(0, 0)), 5);
  });

  test('a cell has six neighbors inside the board and fewer on the edges', () {
    expect(testBoard.neighborPositionsAround(at(3, 2)).length, 6);
    expect(testBoard.neighborPositionsAround(at(0, 2)).length, 4);
    expect(testBoard.neighborPositionsAround(at(0, 0)).length, 3);
    expect(testBoard.neighborPositionsAround(at(1, 0)).toSet(), {at(1, 1), at(0, 0), at(2, 0)});
  });

  test('every neighbor is one step away', () {
    for (final position in testBoard.allPositions) {
      expect(
        testBoard.neighborPositionsAround(position),
        everyElement(predicate<Position>((neighbor) => neighbor.distanceToPosition(position) == 1)),
      );
    }
  });

  test('moving away from an origin follows a straight line', () {
    expect(at(3, 1).positionAwayFrom(at(3, 0), steps: 1), at(3, 2));
    expect(at(3, 1).positionAwayFrom(at(3, 0), steps: 2), at(3, 3));
    expect(at(3, 1).positionAwayFrom(at(2, 1), steps: 1), at(4, 0));
    expect(at(3, 1).positionAwayFrom(at(2, 1), steps: 2), at(5, 0));
    expect(at(3, 1).positionAwayFrom(at(3, 1), steps: 2), at(3, 1));
  });

  test('a cell reaches along its hexagon lines and straight up or down, but not in between', () {
    final center = at(3, 2);
    final distantPositions = testBoard.allPositions.where((position) => position.distanceToPosition(center) == 2);

    expect(testBoard.neighborPositionsAround(center), everyElement(predicate<Position>(center.isAlignedWith)));
    expect(center.isAlignedWith(at(3, 4)), isTrue);
    expect(
      distantPositions.where((position) => (position.centerX - center.centerX).abs() < 1e-9),
      everyElement(predicate<Position>(center.isAlignedWith)),
    );
    expect(distantPositions.where((position) => !center.isAlignedWith(position)), isNotEmpty);
    expect(center.canReach(at(1, 1), 2), center.isAlignedWith(at(1, 1)));
  });

  test('positions are values', () {
    expect(at(1, 2), const Position(row: 1, column: 2));
    expect({at(1, 2), at(1, 2)}.length, 1);
  });
}
