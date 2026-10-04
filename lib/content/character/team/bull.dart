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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';

const Character bull = Character(
  id: CharacterId('bull'),
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageEffect(
        target: EnemiesAroundFocusTarget(),
        value: StarValues(star1: 350, star2: 525, star3: 800),
      ),

      StunEffect(
        target: EnemiesAroundFocusTarget(),
        seconds: StarValues(star1: 1.5, star2: 1.5, star3: 1.5),
      ),

      KnockbackEffect(
        target: EnemiesAroundFocusTarget(),
        cells: 2,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 2.05,
    Stat.damage: 1.65,
    Stat.armor: 2.15,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1.3,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 30,
    Stat.manaMax: 90,
    Stat.range: 1,
  }),
);
