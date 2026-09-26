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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_effect.dart';

const Character rabbit = Character(
  id: CharacterId('rabbit'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      NextHitsStatModifierEffect(
        target: CombatEffectTarget.self,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 2, star2: 2, star3: 2),
        hits: 3,
      ),

      NextHitsStatModifierEffect(
        target: CombatEffectTarget.self,
        stat: Stat.damage,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 30, star2: 45, star3: 70),
        hits: 3,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.95,
    Stat.damage: 1.05,
    Stat.armor: 0.75,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.5,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 40,
    Stat.range: 2,
  }),
);
