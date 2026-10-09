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
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_allies_target.dart';

const Character rooster = Character(
  id: CharacterId('rooster'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      StatModifierEffect(
        target: NearbyAlliesTarget(),
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 1.25, star2: 1.4, star3: 1.6),
        seconds: StarValues(star1: 3, star2: 3, star3: 3),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.85,
    Stat.damage: 1.3,
    Stat.armor: 0.5,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/team/rooster/atlas.webp',
    boardScale: 0.79,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.pulse,
        color: SpriteColor(0xFFFFD23C),
        targets: {HexEffectTarget.self, HexEffectTarget.allies},
        scope: HexEffectScope.target,
        intensity: 1.11,
        tintsUnit: false,
      ),
    ),
  ),
);
