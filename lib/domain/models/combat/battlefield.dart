import 'package:meta/meta.dart';

import 'dart:math';

import 'errors/combatant_not_found_error.dart';
import 'errors/position_not_free_error.dart';

import '../board/board.dart';
import '../board/position.dart';
import '../combatant/combatant.dart';
import '../combatant/faction.dart';

class Battlefield {
  const Battlefield({required this.board, required this.combatants});
  final List<Combatant> combatants;
  final Board board;

  Combatant combatantWithId(int combatantId) {
    final combatant = combatants.where((combatant) => combatant.id == combatantId).firstOrNull;
    if (combatant == null) throw CombatantNotFoundError(combatantId: combatantId);
    return combatant;
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
    final filteredCombatants = combatants.where((combatant) => combatant.isAlive && combatant.position == position);
    return filteredCombatants.firstOrNull;
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
