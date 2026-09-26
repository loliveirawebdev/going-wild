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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';

const Character cow = Character(
  id: CharacterId('cow'),
  role: Role.tank,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      ShieldEffect(
        target: CombatEffectTarget.self,
        value: StarValues(star1: 300, star2: 450, star3: 675),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
        onExpire: [
          DamageEffect(
            target: CombatEffectTarget.nearbyEnemies,
            value: StarValues(star1: 150, star2: 225, star3: 340),
          ),
        ],
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.9,
    Stat.damage: 1.1,
    Stat.armor: 2.3,
    Stat.attackSpeed: 0.85,
    Stat.moveSpeed: 1.1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
