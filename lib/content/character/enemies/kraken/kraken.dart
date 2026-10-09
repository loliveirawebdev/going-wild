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
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/pull/pull_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/farthest_enemy_target.dart';

const Character kraken = Character(
  id: CharacterId('kraken'),
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    trigger: ManaFullTrigger(),
    effects: [PullEffect(target: FarthestEnemyTarget())],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 4,
    Stat.damage: 1.5,
    Stat.armor: 2.2,
    Stat.attackSpeed: 0.9,
    Stat.moveSpeed: 0.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 2,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/enemies/kraken/atlas.webp',
    boardScale: 1.6,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.mist,
        color: SpriteColor(0xFF4AB8FF),
        targets: {HexEffectTarget.enemies},
        scope: HexEffectScope.target,
        intensity: 1.5,
        tintsUnit: true,
      ),
    ),
  ),
);
