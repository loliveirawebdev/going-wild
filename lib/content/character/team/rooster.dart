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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';

const Character rooster = Character(
  id: CharacterId('rooster'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      StatModifierEffect(
        target: CombatEffectTarget.nearbyAllies,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 1.25, star2: 1.4, star3: 1.6),
        seconds: StarValues(star1: 3, star2: 3, star3: 3),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.85,
    Stat.damage: 1.3,
    Stat.armor: 0.5,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
