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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';

const Character dragon = Character(
  id: CharacterId('dragon'),
  role: Role.damage,
  rarity: Rarity.epic,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 400, star2: 600, star3: 900),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 4.5,
    Stat.damage: 2,
    Stat.armor: 2.5,
    Stat.attackSpeed: 0.7,
    Stat.moveSpeed: 1.2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 30,
    Stat.manaMax: 90,
    Stat.range: 4,
  }),
);
