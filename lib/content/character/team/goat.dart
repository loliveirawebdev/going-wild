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
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';

const Character goat = Character(
  id: CharacterId('goat'),
  role: Role.tank,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      KnockbackEffect(
        target: FocusTarget(),
        cells: 1,
      ),

      DamageEffect(
        target: FocusTarget(),
        value: StarValues(star1: 150, star2: 225, star3: 340),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.5,
    Stat.damage: 1.1,
    Stat.armor: 2.05,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1.1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 1,
  }),
);
