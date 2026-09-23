import 'dart:collection';

import '../../models/models.dart';
import '../battle.dart';
import '../board/position.dart';
import '../events/battle_event.dart';
import '../unit/unit.dart';
import 'is_target_in_range.dart';

void moveTowardTarget(Battle battle, Unit unit) {
  final targetUnit = unit.target;
  if (targetUnit == null || isTargetInRange(unit, targetUnit)) return;

  unit.secondsUntilNextStep -= battle.rules.tickSeconds;
  if (unit.secondsUntilNextStep > 0) return;

  final nextStepPosition = findNextStepToward(battle, unit, targetUnit);
  if (nextStepPosition == null) return;

  final previousPosition = unit.position;
  unit.position = nextStepPosition;
  unit.secondsUntilNextStep = 1 / unit.getCurrentStat(Stat.moveSpeed);

  battle.recordEvent(
    CharacterMoved(
      time: battle.elapsedSeconds,
      unitId: unit.id,
      from: previousPosition,
      to: nextStepPosition,
    ),
  );
}

Position? findNextStepToward(Battle battle, Unit unit, Unit targetUnit) {
  final range = unit.getCurrentStat(Stat.range);
  bool reachesTarget(Position position) => position.distanceToPosition(targetUnit.position) <= range;

  final previousPositionOf = <Position, Position?>{unit.position: null};
  final positionsToVisit = Queue<Position>()..add(unit.position);
  Position? destinationPosition;

  while (positionsToVisit.isNotEmpty) {
    final visitingPosition = positionsToVisit.removeFirst();

    if (visitingPosition != unit.position && reachesTarget(visitingPosition)) {
      destinationPosition = visitingPosition;
      break;
    }

    for (final neighborPosition in _neighborPositionsClosestToGoal(battle, visitingPosition, targetUnit.position)) {
      if (previousPositionOf.containsKey(neighborPosition) || !battle.isPositionFree(neighborPosition)) continue;
      previousPositionOf[neighborPosition] = visitingPosition;
      positionsToVisit.add(neighborPosition);
    }
  }

  if (destinationPosition == null) return null;

  var firstStepPosition = destinationPosition;
  while (previousPositionOf[firstStepPosition] != unit.position) firstStepPosition = previousPositionOf[firstStepPosition]!;
  return firstStepPosition;
}

List<Position> _neighborPositionsClosestToGoal(Battle battle, Position fromPosition, Position goalPosition) {
  int manhattanDistanceToGoal(Position position) => (position.row - goalPosition.row).abs() + (position.column - goalPosition.column).abs();

  return battle.board.neighborPositionsAround(fromPosition).toList()..sort((firstNeighbor, secondNeighbor) {
    final distanceOrder = firstNeighbor.distanceToPosition(goalPosition).compareTo(secondNeighbor.distanceToPosition(goalPosition));
    if (distanceOrder != 0) return distanceOrder;

    final straightnessOrder = manhattanDistanceToGoal(firstNeighbor).compareTo(manhattanDistanceToGoal(secondNeighbor));
    if (straightnessOrder != 0) return straightnessOrder;

    final rowOrder = firstNeighbor.row.compareTo(secondNeighbor.row);
    return rowOrder != 0 ? rowOrder : firstNeighbor.column.compareTo(secondNeighbor.column);
  });
}
