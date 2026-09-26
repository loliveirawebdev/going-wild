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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';

const Character bear = Character(
  id: CharacterId('bear'),
  role: Role.tank,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 250, star2: 375, star3: 560),
      ),

      KnockbackEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        cells: 1,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 3,
    Stat.damage: 1.4,
    Stat.armor: 2.2,
    Stat.attackSpeed: 0.6,
    Stat.moveSpeed: 1.1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 90,
    Stat.range: 1,
  }),
);
