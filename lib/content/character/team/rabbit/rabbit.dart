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

const Character rabbit = Character(
  id: CharacterId('rabbit'),
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      NextHitsStatModifierEffect(
        target: SelfTarget(),
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 2, star2: 2, star3: 2),
        hits: 3,
      ),

      NextHitsStatModifierEffect(
        target: SelfTarget(),
        stat: Stat.damage,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 30, star2: 45, star3: 70),
        hits: 3,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.95,
    Stat.damage: 1.05,
    Stat.armor: 0.75,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.5,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 40,
    Stat.range: 2,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/team/rabbit/atlas.webp',
    boardScale: 0.85,
    movement: HoppingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.aura,
        color: SpriteColor(0xFFFFD23C),
        targets: {HexEffectTarget.self},
        scope: HexEffectScope.target,
        intensity: 0.61,
        tintsUnit: true,
      ),
    ),
  ),
);
