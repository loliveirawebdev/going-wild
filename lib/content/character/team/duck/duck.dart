import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/sprite/ability_visuals.dart';
import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';

const Character duck = Character(
  id: CharacterId('duck'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageEffect(
        target: EnemiesAroundFocusTarget(),
        value: StarValues(star1: 130, star2: 195, star3: 290),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.9,
    Stat.damage: 1.2,
    Stat.armor: 0.75,
    Stat.attackSpeed: 1.05,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 2,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/team/duck/atlas.webp',
    boardScale: 0.85,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(),
  ),
);
