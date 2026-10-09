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
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';

const Character snake = Character(
  id: CharacterId('snake'),
  role: Role.damage,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageOverTimeEffect(
        target: FocusTarget(),
        damagePerSecond: StarValues(star1: 30, star2: 45, star3: 70),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.9,
    Stat.damage: 1,
    Stat.armor: 0.8,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 0.7,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 50,
    Stat.range: 1,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/enemies/snake/atlas.webp',
    boardScale: 1,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.mist,
        color: SpriteColor(0xFF4DFF88),
        targets: {HexEffectTarget.enemies},
        scope: HexEffectScope.target,
        intensity: 0.32,
        tintsUnit: true,
      ),
    ),
  ),
);
