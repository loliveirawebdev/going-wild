import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_effect.dart';

const Character queenBee = Character(
  id: CharacterId('queenBee'),
  role: Role.support,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageOverTimeEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        damagePerSecond: StarValues(star1: 60, star2: 90, star3: 135),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.3,
    Stat.damage: 1.2,
    Stat.armor: 1.05,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 1.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 4,
  }),
);
