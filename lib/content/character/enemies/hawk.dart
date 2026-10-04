import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/lowest_health_enemy_target.dart';

const Character hawk = Character(
  id: CharacterId('hawk'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageEffect(
        target: LowestHealthEnemyTarget(),
        value: StarValues(star1: 140, star2: 210, star3: 320),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.55,
    Stat.damage: 0.9,
    Stat.armor: 0.4,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 1.3,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 2,
  }),
);
