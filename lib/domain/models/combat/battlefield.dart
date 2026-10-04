import 'dart:math';

import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat/errors/combatant_not_found_error.dart';
import 'package:going_wild/domain/models/combat/errors/position_not_free_error.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

class Battlefield {
  const Battlefield({required this.board, required this.combatants});
  final List<Combatant> combatants;
  final Board board;

  Combatant combatantWithId(int combatantId) {
    for (final combatant in combatants) {
      if (combatant.id == combatantId) return combatant;
    }

    throw CombatantNotFoundError(combatantId: combatantId);
  }

  @useResult
  Battlefield createCopyWithCombatantMovedTo(int combatantId, Position position) {
    if (!isPositionFree(position)) throw PositionNotFreeError(combatantId: combatantId, position: position);
    return createCopyWithCombatant(combatantWithId(combatantId).createCopyWith(position: position));
  }

  @useResult
  Battlefield createCopyWithCombatant(Combatant updatedCombatant) => Battlefield(
    board: board,
    combatants: [for (final combatant in combatants) combatant.id == updatedCombatant.id ? updatedCombatant : combatant],
  );

  bool isPositionFree(Position position) {
    return board.isPositionWithinBounds(position) && //
        _aliveCombatantAtPosition(position) == null;
  }

  Iterable<Combatant> targetableCombatantsFromFaction(Faction faction) {
    return combatants.where(
      (combatant) =>
          combatant.isTargetable && //
          combatant.faction == faction,
    );
  }

  Iterable<Combatant> aliveCombatantsFromFaction(Faction faction) {
    return combatants.where(
      (combatant) =>
          combatant.isAlive && //
          combatant.faction == faction,
    );
  }

  Combatant? _aliveCombatantAtPosition(Position position) {
    for (final combatant in combatants) {
      if (combatant.isAlive && combatant.position == position) return combatant;
    }

    return null;
  }

  Position? pickRandomFreePositionClosestTo(Position origin, Random randomGenerator) {
    final farthestPossibleDistance = max(board.rows, board.columns);

    for (var distance = 1; distance <= farthestPossibleDistance; distance++) {
      final freePositionsAtDistance = board.allPositions
          .where((position) => position.distanceToPosition(origin) == distance && isPositionFree(position))
          .toList();

      if (freePositionsAtDistance.isNotEmpty) {
        final randomIndex = randomGenerator.nextInt(freePositionsAtDistance.length);
        return freePositionsAtDistance[randomIndex];
      }
    }

    return null;
  }
}
