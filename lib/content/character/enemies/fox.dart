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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/ambush_effect.dart';

const Character fox = Character(
  id: CharacterId('fox'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: AbilityTrigger.lowHealth,

    effects: [
      AmbushEffect(
        target: CombatEffectTarget.lowestHealthEnemy,
        seconds: StarValues(star1: 1, star2: 1, star3: 1),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.8,
    Stat.damage: 1.1,
    Stat.armor: 0.6,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 40,
    Stat.range: 1,
  }),
);
