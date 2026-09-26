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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_effect.dart';

const Character dog = Character(
  id: CharacterId('dog'),
  role: Role.guard,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      TauntEffect(
        target: CombatEffectTarget.allEnemies,
        seconds: StarValues(star1: 2, star2: 2, star3: 2),
      ),

      StatModifierEffect(
        target: CombatEffectTarget.self,
        stat: Stat.armor,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 30, star2: 50, star3: 80),
        seconds: StarValues(star1: 2, star2: 2, star3: 2),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.45,
    Stat.damage: 1.2,
    Stat.armor: 1.9,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 1.6,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
