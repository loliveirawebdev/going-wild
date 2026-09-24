import 'dart:math';

import '../models.dart';
import 'battle_rules.dart';
import 'board/board.dart';
import 'board/faction.dart';
import 'board/position.dart';
import 'events/battle_event.dart';
import 'unit/unit.dart';

typedef DeferredEffects = ({
  Unit casterUnit,
  List<AbilityEffect> effects,
});

class Battle {
  Battle({
    required this.board,
    required this.rules,
    required this.units,
    required this.randomGenerator,
  });

  double elapsedSeconds = 0;

  final Board board;
  final List<Unit> units;
  final BattleRules rules;
  final Random randomGenerator;
  final List<BattleEvent> events = [];
  final List<DeferredEffects> deferredEffects = [];

  void recordEvent(BattleEvent event) => events.add(event);

  bool isPositionFree(Position p) => board.isPositionWithinBounds(p) && targetableUnitAtPosition(p) == null;
  Iterable<Unit> targetableUnitsFromFaction(Faction f) => units.where((u) => u.isTargetable && u.faction == f);
  Iterable<Unit> aliveUnitsFromFaction(Faction faction) => units.where((u) => u.isAlive && u.faction == faction);
  Unit? targetableUnitAtPosition(Position p) => units.where((u) => u.isTargetable && u.position == p).firstOrNull;

  Position? pickRandomFreePositionClosestTo(Position origin) {
    final farthestPossibleDistance = max(board.rows, board.columns);

    for (var distance = 1; distance <= farthestPossibleDistance; distance++) {
      final freeCellsAtDistance = board.allPositions
          .where((position) => position.distanceToPosition(origin) == distance && isPositionFree(position))
          .toList();

      if (freeCellsAtDistance.isNotEmpty) {
        return freeCellsAtDistance[randomGenerator.nextInt(freeCellsAtDistance.length)];
      }
    }

    return null;
  }
}
