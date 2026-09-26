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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';

const Character boar = Character(
  id: CharacterId('boar'),
  role: Role.tank,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      KnockbackEffect(
        target: CombatEffectTarget.focus,
        cells: 1,
      ),

      StunEffect(
        target: CombatEffectTarget.focus,
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.6,
    Stat.damage: 0.9,
    Stat.armor: 1.5,
    Stat.attackSpeed: 0.7,
    Stat.moveSpeed: 1.3,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
