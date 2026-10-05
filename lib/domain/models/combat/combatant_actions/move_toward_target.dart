import 'dart:collection';

import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

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
  return combat.battlefield.board.neighborPositionsAround(fromPosition).toList()..sort((firstNeighbor, secondNeighbor) {
    final distanceOrder = firstNeighbor.distanceToPosition(goalPosition).compareTo(secondNeighbor.distanceToPosition(goalPosition));
    if (distanceOrder != 0) return distanceOrder;

    final straightnessOrder = firstNeighbor
        .straightLineDistanceToPosition(goalPosition)
        .compareTo(secondNeighbor.straightLineDistanceToPosition(goalPosition));

    if (straightnessOrder != 0) return straightnessOrder;

    final rowOrder = firstNeighbor.row.compareTo(secondNeighbor.row);
    return rowOrder != 0 ? rowOrder : firstNeighbor.column.compareTo(secondNeighbor.column);
  });
}
