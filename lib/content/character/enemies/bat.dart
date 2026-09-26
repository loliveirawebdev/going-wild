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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/lifesteal/lifesteal_effect.dart';

const Character bat = Character(
  id: CharacterId('bat'),
  role: Role.damage,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      LifestealEffect(
        target: CombatEffectTarget.focus,
        value: StarValues(star1: 120, star2: 180, star3: 270),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.6,
    Stat.damage: 0.9,
    Stat.armor: 0.4,
    Stat.attackSpeed: 1.1,
    Stat.moveSpeed: 1.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
