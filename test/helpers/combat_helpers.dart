import 'dart:math';

import 'package:going_wild/content/board.dart';
import 'package:going_wild/content/engines/combat/basic_combat_engine.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combat/battlefield.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

final testRules = basicCombatEngine.rules;

const testBoard = board;
const noAbility = Ability(effects: [], trigger: ManaFullTrigger());

Character dummy({Role role = Role.damage, Ability ability = noAbility, CharacterId id = const CharacterId('cat')}) => Character(
  id: id,
  role: role,
  ability: ability,
  rarity: Rarity.common,
  statMultipliers: const StatMultipliers({}),
);

Stats statsOf({
  double armor = 0,
  double range = 1,
  double damage = 100,
  double manaMax = 50,
  double health = 1000,
  double moveSpeed = 1,
  double manaStart = 0,
  double attackSpeed = 1,
  double damageTakenPercentage = 1,
}) => Stats({
  Stat.health: health,
  Stat.damage: damage,
  Stat.armor: armor,
  Stat.attackSpeed: attackSpeed,
  Stat.moveSpeed: moveSpeed,
  Stat.damageTakenPercentage: damageTakenPercentage,
  Stat.manaStart: manaStart,
  Stat.manaMax: manaMax,
  Stat.range: range,
});

int _nextId = 1;

Combatant combatant({
  required Position at,
  required Faction faction,
  Stats? stats,
  int stars = 1,
  Character? character,
}) {
  final combatantStats = stats ?? statsOf();

  return Combatant(
    position: at,
    id: _nextId++,
    faction: faction,
    stats: combatantStats,
    ticksUntilNextStep: 0,
    targetCombatantId: null,
    ticksUntilNextAttack: 0,
    abilityCastCount: 0,
    combatLastingEffects: const [],
    currentHealth: combatantStats[Stat.health],
    currentMana: combatantStats[Stat.manaStart],
    characterCopy: CharacterCopy(stars: stars, character: character ?? dummy()),
  );
}

Combat combatWith(List<Combatant> combatants, {int seed = 1}) {
  return Combat(
    elapsedTicks: 0,
    rules: testRules,
    randomGenerator: Random(seed),
    pendingCombatEffectApplications: const [],
    battlefield: Battlefield(board: testBoard, combatants: combatants),
  );
}

Position at(int row, int column) => Position(row: row, column: column);

StarValues atEveryStar(double value) => StarValues(star1: value, star2: value, star3: value);

Ability ability(List<CombatEffect> effects, {AbilityTrigger trigger = const ManaFullTrigger()}) {
  return Ability(
    trigger: trigger,
    effects: effects,
  );
}

Combatant findCombatant(Combat combat, Combatant combatant) => combat.battlefield.combatantWithId(combatant.id);

Combatant withCombatLastingEffects(Combatant combatant, List<CombatLastingEffect> combatLastingEffects) =>
    combatant.createCopyWith(combatLastingEffects: combatLastingEffects);
