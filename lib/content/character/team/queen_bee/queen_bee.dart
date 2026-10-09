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
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';

const Character queenBee = Character(
  id: CharacterId('queenBee'),
  role: Role.support,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageOverTimeEffect(
        target: EnemiesAroundFocusTarget(),
        damagePerSecond: StarValues(star1: 60, star2: 90, star3: 135),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.3,
    Stat.damage: 1.2,
    Stat.armor: 1.05,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 1.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 4,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/team/queen_bee/atlas.webp',
    boardScale: 0.55,
    movement: FlyingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.mist,
        color: SpriteColor(0xFFFFD23C),
        targets: {HexEffectTarget.enemies},
        scope: HexEffectScope.targetAndNeighbors,
        intensity: 0.24,
        tintsUnit: true,
      ),
    ),
  ),
);
