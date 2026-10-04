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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/farthest_enemy_target.dart';

const Character owl = Character(
  id: CharacterId('owl'),
  role: Role.damage,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageEffect(
        target: FarthestEnemyTarget(),
        value: StarValues(star1: 220, star2: 330, star3: 500),
      ),

      StunEffect(
        target: FarthestEnemyTarget(),
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.8,
    Stat.damage: 1.2,
    Stat.armor: 0.6,
    Stat.attackSpeed: 0.8,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 80,
    Stat.range: 4,
  }),
);
