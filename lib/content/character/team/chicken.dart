import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_allies_target.dart';

const Character chicken = Character(
  id: CharacterId('chicken'),
  role: Role.support,
  rarity: Rarity.common,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      HealOverTimeEffect(
        target: NearbyAlliesTarget(),
        healPerSecond: StarValues(star1: 40, star2: 60, star3: 90),
        seconds: StarValues(star1: 3, star2: 3, star3: 3),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1,
    Stat.damage: 1,
    Stat.armor: 1,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 2,
  }),
);
