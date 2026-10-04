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
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';

const Character acromantula = Character(
  id: CharacterId('acromantula'),
  role: Role.guard,
  rarity: Rarity.epic,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageEffect(
        target: EnemiesAroundFocusTarget(),
        value: StarValues(star1: 600, star2: 900, star3: 1350),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 2.8,
    Stat.damage: 1.2,
    Stat.armor: 1.8,
    Stat.attackSpeed: 0.8,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 60,
    Stat.manaMax: 150,
    Stat.range: 2,
  }),
);
