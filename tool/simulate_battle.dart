import 'dart:io';
import 'dart:math';

import 'package:going_wild/data/character/base_stats.dart';
import 'package:going_wild/data/character/enemies/enemies.dart';
import 'package:going_wild/data/character/merge_curves/merge_curves.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/combat/battle_rules.dart' as rules;
import 'package:going_wild/data/set/sets.dart';
import 'package:going_wild/domain/models/combat/battle_rules.dart';
import 'package:going_wild/domain/models/combat/board/board.dart';
import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/events/combat/battle_event.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/use_cases/combat/run_battle.dart';

const seed = 7;
const maxSeconds = 60.0;

final team = [
  place(dog, row: 6, column: 1),
  place(cat, row: 6, column: 3),
  place(chicken, row: 7, column: 2),
];

final enemies = [
  place(rat, row: 1, column: 0),
  place(rat, row: 1, column: 4),
  place(fox, row: 0, column: 2),
];

Placement place(Character character, {required int row, required int column, int stars = 1}) => Placement(
  character: character,
  stars: stars,
  position: Position(row: row, column: column),
);

void main() {
  final result = runBattle(
    team: team,
    enemies: enemies,
    board: const Board(rows: rules.boardRows, columns: rules.boardColumns),
    rules: const BattleRules(
      tickSeconds: rules.tickSeconds,
      manaPerHit: rules.manaPerHit,
      nearbyRadius: rules.nearbyRadius,
      lowHealthTriggerPercentage: rules.lowHealthTriggerPercentage,
      maxSeconds: maxSeconds,
    ),
    baseStats: baseStats,
    mergeCurveFor: mergeCurveFor,
    sets: allSets,
    randomGenerator: Random(seed),
  );

  final placementsInIdOrder = [...team, ...enemies];
  String nameOf(int unitId) {
    final placement = placementsInIdOrder[unitId - 1];
    final stars = '★' * placement.stars;
    return '${placement.character.id}#$unitId$stars';
  }

  for (final event in result.events) stdout.writeln('[${event.time.toStringAsFixed(1).padLeft(5)}s] ${describe(event, nameOf)}');

  stdout.writeln('');
  stdout.writeln('winner: ${result.winningFaction?.name ?? 'draw'} after ${result.elapsedSeconds.toStringAsFixed(1)}s');
  for (final unit in result.survivingUnits) {
    stdout.writeln('  ${unit.faction.name.padRight(5)} ${nameOf(unit.id).padRight(16)} health ${unit.currentHealth.toStringAsFixed(0)}');
  }
}

String describe(BattleEvent event, String Function(int unitId) nameOf) => switch (event) {
  BattleStarted() => 'battle started',
  BattleEnded() => 'battle ended, winner: ${event.winner?.name ?? 'draw'}',
  CharacterNewTargetAcquired() => '${nameOf(event.unitId)} targets ${nameOf(event.targetUnitId)}',
  CharacterMoved() => '${nameOf(event.unitId)} moves ${describePosition(event.from)} -> ${describePosition(event.to)}',
  CharacterAttackLanded() => '${nameOf(event.unitId)} attacks ${nameOf(event.targetUnitId)}',
  CharacterDamaged() =>
    '${nameOf(event.unitId)} takes ${event.amount.toStringAsFixed(0)} from ${nameOf(event.sourceId)}'
        '${event.absorbedByShield > 0 ? ' (${event.absorbedByShield.toStringAsFixed(0)} absorbed)' : ''}'
        ', health ${event.remainingHealth.toStringAsFixed(0)}',
  CharacterDied() => '${nameOf(event.unitId)} dies, killed by ${nameOf(event.killerUnitId)}',
  CharacterReceivedHeal() =>
    '${nameOf(event.unitId)} heals ${event.amount.toStringAsFixed(0)} from ${nameOf(event.sourceUnitId)}, health ${event.healthAfterHeal.toStringAsFixed(0)}',
  CharacterReceivedMana() =>
    '${nameOf(event.unitId)} gains ${event.amount.toStringAsFixed(0)} mana, mana ${event.manaAfterReceived.toStringAsFixed(0)}',
  CharacterReceivedShield() => '${nameOf(event.unitId)} shielded for ${event.amount.toStringAsFixed(0)} by ${nameOf(event.sourceUnitId)}',
  CharacterAbilityCast() => '${nameOf(event.unitId)} casts ${event.abilityId}',
  CharacterStatusEffectStarted() => '${nameOf(event.unitId)} gets ${event.statusEffectKind.name} from ${nameOf(event.sourceUnitId)}',
  CharacterStatusEffectEnded() => '${nameOf(event.unitId)} loses ${event.statusEffectKind.name}',
};

String describePosition(Position position) => '(${position.row},${position.column})';
