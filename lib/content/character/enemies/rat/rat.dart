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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/self_target.dart';

const Character rat = Character(
  id: CharacterId('rat'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      NextHitsStatModifierEffect(
        target: SelfTarget(),
        stat: Stat.damage,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 15, star2: 25, star3: 40),
        hits: 1,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.35,
    Stat.damage: 0.5,
    Stat.armor: 0.5,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 30,
    Stat.range: 1,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/enemies/rat/atlas.webp',
    boardScale: 0.83,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.paint,
        color: SpriteColor(0xFFB46BFF),
        targets: {HexEffectTarget.self},
        scope: HexEffectScope.target,
        intensity: 0.4,
        tintsUnit: true,
        duration: Duration(milliseconds: 1500),
      ),
    ),
  ),
);
