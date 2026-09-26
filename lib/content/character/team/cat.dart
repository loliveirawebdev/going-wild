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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/mana_refund_on_kill/mana_refund_on_kill_effect.dart';

const Character cat = Character(
  id: CharacterId('cat'),
  role: Role.damage,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: CombatEffectTarget.lowestHealthEnemy,
        value: StarValues(star1: 200, star2: 300, star3: 450),
      ),

      ManaRefundOnKillEffect(
        percentage: 50,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.1,
    Stat.damage: 1.55,
    Stat.armor: 0.9,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.6,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 1,
  }),
);
