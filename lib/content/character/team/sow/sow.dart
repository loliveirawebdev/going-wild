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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_enemies_target.dart';

const Character sow = Character(
  id: CharacterId('sow'),
  role: Role.support,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      StatModifierEffect(
        target: NearbyEnemiesTarget(),
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 0.6, star2: 0.6, star3: 0.6),
        seconds: StarValues(star1: 2, star2: 3, star3: 4),
      ),

      DamageEffect(
        target: NearbyEnemiesTarget(),
        value: StarValues(star1: 80, star2: 120, star3: 180),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.4,
    Stat.damage: 1.1,
    Stat.armor: 1.6,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/team/sow/atlas.webp',
    boardScale: 1,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.pulse,
        color: SpriteColor(0xFF5B2420),
        targets: {HexEffectTarget.enemies},
        scope: HexEffectScope.targetAndNeighbors,
        intensity: 0.43,
        tintsUnit: false,
      ),
    ),
  ),
);
