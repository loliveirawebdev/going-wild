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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';

const Character sheep = Character(
  id: CharacterId('sheep'),
  role: Role.support,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      ShieldEffect(
        target: CombatEffectTarget.lowestHealthAlly,
        value: StarValues(star1: 200, star2: 300, star3: 450),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.3,
    Stat.damage: 0.95,
    Stat.armor: 1.4,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 30,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
