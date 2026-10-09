import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/sprite/ability_visuals.dart';
import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';
import 'package:going_wild/domain/models/character/sprite/hex_effect.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_color.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';

const Character skunk = Character(
  id: CharacterId('skunk'),
  role: Role.support,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      StatModifierEffect(
        target: EnemiesAroundFocusTarget(),
        stat: Stat.damage,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 0.7, star2: 0.7, star3: 0.7),
        seconds: StarValues(star1: 3, star2: 4, star3: 5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.8,
    Stat.damage: 0.7,
    Stat.armor: 0.6,
    Stat.attackSpeed: 0.9,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 10,
    Stat.manaMax: 60,
    Stat.range: 2,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/enemies/skunk/atlas.webp',
    boardScale: 0.97,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.mist,
        color: SpriteColor(0xFF3C2525),
        targets: {HexEffectTarget.self, HexEffectTarget.enemies},
        scope: HexEffectScope.target,
        intensity: 0.56,
        tintsUnit: true,
      ),
    ),
  ),
);
