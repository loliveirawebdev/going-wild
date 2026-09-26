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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';

const Character guineaPig = Character(
  id: CharacterId('guineaPig'),
  role: Role.guard,
  rarity: Rarity.common,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      StunEffect(
        target: CombatEffectTarget.enemiesAroundFocus,
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2.5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.2,
    Stat.damage: 1,
    Stat.armor: 1.3,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
