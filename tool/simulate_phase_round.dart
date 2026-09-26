import 'dart:io';
import 'dart:math';

import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/combat/basic_combat_engine.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/vanished_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';

const seed = 7;

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
  position: Position(row: row, column: column),
  characterCopy: CharacterCopy(stars: stars, character: character),
);

void main() {
  final result = basicCombatEngine.simulate(team: team, enemies: enemies, randomGenerator: Random(seed));

  String nameOf(int? combatantId) {
    if (combatantId == null) return 'lasting effects';

    final combatant = result.combatants.firstWhere((combatant) => combatant.id == combatantId);
    final stars = '★' * combatant.characterCopy.stars;
    return '${combatant.characterCopy.character.id.value}#$combatantId$stars';
  }

  for (final entry in result.history.entries) {
    final seconds = entry.tick / basicCombatEngine.rules.ticksPerSecond;
    stdout.writeln('[${seconds.toStringAsFixed(1).padLeft(5)}s] ${describe(entry, nameOf)}');
  }

  printSurvivors(result, nameOf);
}

void printSurvivors(CombatResult result, String Function(int? combatantId) nameOf) {
  stdout.writeln('');
  stdout.writeln('winner: ${result.winningFaction?.name ?? 'draw'} after ${result.elapsedSeconds.toStringAsFixed(1)}s');

  for (final combatant in result.survivingCombatants) {
    final health = combatant.currentHealth.toStringAsFixed(0);
    stdout.writeln('  ${combatant.faction.name.padRight(5)} ${nameOf(combatant.id).padRight(16)} health $health');
  }
}

String describe(CombatHistoryEntry entry, String Function(int? combatantId) nameOf) => switch (entry) {
  CombatStartedHistoryEntry() => 'combat started',
  CombatEndedHistoryEntry() => 'combat ended, winner: ${entry.winningFaction?.name ?? 'draw'}',
  TargetAcquiredHistoryEntry() => '${nameOf(entry.combatantId)} targets ${nameOf(entry.targetCombatantId)}',
  MovementHistoryEntry() => describeMovement(entry, nameOf),
  AttackLandedHistoryEntry() => '${nameOf(entry.combatantId)} attacks ${nameOf(entry.targetCombatantId)}',
  AbilityCastHistoryEntry() => '${nameOf(entry.combatantId)} casts its ability',
  DamageTakenHistoryEntry() => describeDamageTaken(entry, nameOf),
  HealReceivedHistoryEntry() =>
    '${nameOf(entry.combatantId)} heals ${entry.amount.toStringAsFixed(0)} from ${nameOf(entry.sourceCombatantId)}, '
        'health ${entry.currentHealth.toStringAsFixed(0)}',
  ManaReceivedHistoryEntry() =>
    '${nameOf(entry.combatantId)} gains ${entry.amount.toStringAsFixed(0)} mana, mana ${entry.currentMana.toStringAsFixed(0)}',
  DeathHistoryEntry() => '${nameOf(entry.combatantId)} dies, killed by ${nameOf(entry.killerCombatantId)}',
  LastingEffectStartedHistoryEntry() =>
    '${nameOf(entry.combatantId)} gets ${describeLastingEffect(entry.combatLastingEffect)} '
        'from ${nameOf(entry.combatLastingEffect.sourceCombatantId)}',
  LastingEffectEndedHistoryEntry() => '${nameOf(entry.combatantId)} loses ${describeLastingEffect(entry.combatLastingEffect)}',
};

String describeMovement(MovementHistoryEntry entry, String Function(int? combatantId) nameOf) {
  final route = '${describePosition(entry.fromPosition)} -> ${describePosition(entry.toPosition)}';
  if (entry.sourceCombatantId == entry.combatantId) return '${nameOf(entry.combatantId)} moves $route';

  return '${nameOf(entry.combatantId)} is moved $route by ${nameOf(entry.sourceCombatantId)}';
}

String describeDamageTaken(DamageTakenHistoryEntry entry, String Function(int? combatantId) nameOf) {
  final absorbed = entry.absorbedByShield > 0 ? ' (${entry.absorbedByShield.toStringAsFixed(0)} absorbed)' : '';
  final damage = entry.amount.toStringAsFixed(0);

  return '${nameOf(entry.combatantId)} takes $damage from ${nameOf(entry.sourceCombatantId)}$absorbed, '
      'health ${entry.currentHealth.toStringAsFixed(0)}';
}

String describeLastingEffect(CombatLastingEffect combatLastingEffect) => switch (combatLastingEffect) {
  StunCombatLastingEffect() => 'stun',
  TauntCombatLastingEffect() => 'taunt',
  VanishedCombatLastingEffect() => 'vanished',
  DamageOverTimeCombatLastingEffect() => 'poison',
  HealOverTimeCombatLastingEffect() => 'heal over time',
  ShieldCombatLastingEffect() => 'shield ${combatLastingEffect.remainingShield.toStringAsFixed(0)}',
  StatModifierCombatLastingEffect() => 'stat modifier on ${combatLastingEffect.statModification.stat.name}',
  NextHitsStatModifierCombatLastingEffect() => 'next hits modifier on ${combatLastingEffect.statModification.stat.name}',
  _ => combatLastingEffect.runtimeType.toString(),
};

String describePosition(Position position) => '(${position.row},${position.column})';
