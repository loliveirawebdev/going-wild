import 'dart:collection';

import 'package:meta/meta.dart';

import '../../board/position.dart';
import '../../character/stats/stat.dart';
import '../../combatant/combatant.dart';
import '../combat.dart';

@useResult
Combat moveTowardTarget(Combat combat, int combatantId) {
  final combatant = combat.battlefield.combatantWithId(combatantId);
  final targetCombatantId = combatant.targetCombatantId;
  if (targetCombatantId == null) return combat;

  final combatantRange = combatant.getCurrentStat(Stat.range);
  final targetCombatant = combat.battlefield.combatantWithId(targetCombatantId);
  final isTargetInRange = combatant.position.isWithinRange(targetCombatant.position, combatantRange);
  if (!targetCombatant.isTargetable || isTargetInRange) return combat;

  final ticksUntilNextStep = combatant.ticksUntilNextStep - 1;
  final waitingCombatant = combatant.createCopyWith(ticksUntilNextStep: ticksUntilNextStep);
  final waitingCombat = combat.createCopyWithCombatant(waitingCombatant);
  if (ticksUntilNextStep > 0) return waitingCombat;

  final nextStepPosition = findNextStepToward(waitingCombat, waitingCombatant, targetCombatant);
  if (nextStepPosition == null) return waitingCombat;

  final movedCombat = waitingCombat.createCopyWithCombatantMovedTo(combatantId, nextStepPosition);
  final movedCombatant = movedCombat.battlefield.combatantWithId(combatantId);
  final ticksUntilStepAfterMoving = combat.rules.ticksBetweenActions(movedCombatant.getCurrentStat(Stat.moveSpeed));

  return movedCombat.createCopyWithCombatant(movedCombatant.createCopyWith(ticksUntilNextStep: ticksUntilStepAfterMoving));
}

Position? findNextStepToward(Combat combat, Combatant combatant, Combatant targetCombatant) {
  final range = combatant.getCurrentStat(Stat.range);

  final previousPositionOf = <Position, Position?>{combatant.position: null};
  final positionsToVisit = Queue<Position>()..add(combatant.position);
  Position? destinationPosition;

  while (positionsToVisit.isNotEmpty) {
    final visitingPosition = positionsToVisit.removeFirst();

    if (visitingPosition != combatant.position && visitingPosition.isWithinRange(targetCombatant.position, range)) {
      destinationPosition = visitingPosition;
      break;
    }

    for (final neighborPosition in _neighborPositionsClosestToGoal(combat, visitingPosition, targetCombatant.position)) {
      final wasAlreadyVisited = previousPositionOf.containsKey(neighborPosition);
      if (wasAlreadyVisited || !combat.battlefield.isPositionFree(neighborPosition)) continue;

      previousPositionOf[neighborPosition] = visitingPosition;
      positionsToVisit.add(neighborPosition);
    }
  }

  if (destinationPosition == null) return null;

  var firstStepPosition = destinationPosition;
  while (previousPositionOf[firstStepPosition] != combatant.position) firstStepPosition = previousPositionOf[firstStepPosition]!;

  return firstStepPosition;
}

List<Position> _neighborPositionsClosestToGoal(Combat combat, Position fromPosition, Position goalPosition) {
  int manhattanDistanceToGoal(Position position) => (position.row - goalPosition.row).abs() + (position.column - goalPosition.column).abs();

  return combat.battlefield.board.neighborPositionsAround(fromPosition).toList()..sort((firstNeighbor, secondNeighbor) {
    final distanceOrder = firstNeighbor.distanceToPosition(goalPosition).compareTo(secondNeighbor.distanceToPosition(goalPosition));
    if (distanceOrder != 0) return distanceOrder;

    final straightnessOrder = manhattanDistanceToGoal(firstNeighbor).compareTo(manhattanDistanceToGoal(secondNeighbor));
    if (straightnessOrder != 0) return straightnessOrder;

    final rowOrder = firstNeighbor.row.compareTo(secondNeighbor.row);
    return rowOrder != 0 ? rowOrder : firstNeighbor.column.compareTo(secondNeighbor.column);
  });
}
