import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';

const Character sow = Character(
  id: CharacterId('sow'),
  role: Role.support,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      StatModifierEffect(
        target: CombatEffectTarget.nearbyEnemies,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 0.6, star2: 0.6, star3: 0.6),
        seconds: StarValues(star1: 2, star2: 3, star3: 4),
      ),

      DamageEffect(
        target: CombatEffectTarget.nearbyEnemies,
        value: StarValues(star1: 80, star2: 120, star3: 180),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.4,
    Stat.damage: 1.1,
    Stat.armor: 1.6,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
