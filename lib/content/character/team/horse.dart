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

const Character horse = Character(
  id: CharacterId('horse'),
  role: Role.damage,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 250, star2: 375, star3: 560),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.4,
    Stat.damage: 1.8,
    Stat.armor: 1.2,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
