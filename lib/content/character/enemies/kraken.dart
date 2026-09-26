import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/pull/pull_effect.dart';

const Character kraken = Character(
  id: CharacterId('kraken'),
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,
    effects: [PullEffect(target: CombatEffectTarget.farthestEnemy)],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 4,
    Stat.damage: 1.5,
    Stat.armor: 2.2,
    Stat.attackSpeed: 0.9,
    Stat.moveSpeed: 0.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 2,
  }),
);
