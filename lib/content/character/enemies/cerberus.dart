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

const Character cerberus = Character(
  id: CharacterId('cerberus'),
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 220, star2: 330, star3: 500),
      ),

      StatModifierEffect(
        target: CombatEffectTarget.self,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 1.4, star2: 1.6, star3: 1.8),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 3.5,
    Stat.damage: 1.6,
    Stat.armor: 2.4,
    Stat.attackSpeed: 0.8,
    Stat.moveSpeed: 1.5,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
