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
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/all_enemies_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/self_target.dart';

const Character dog = Character(
  id: CharacterId('dog'),
  role: Role.guard,
  rarity: Rarity.uncommon,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      TauntEffect(
        target: AllEnemiesTarget(),
        seconds: StarValues(star1: 2, star2: 2, star3: 2),
      ),

      StatModifierEffect(
        target: SelfTarget(),
        stat: Stat.armor,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 30, star2: 50, star3: 80),
        seconds: StarValues(star1: 2, star2: 2, star3: 2),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.45,
    Stat.damage: 1.2,
    Stat.armor: 1.9,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 1.6,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/team/dog/atlas.webp',
    boardScale: 0.93,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      hexEffect: HexEffect(
        kind: HexEffectKind.pulse,
        color: SpriteColor(0xFFB46BFF),
        targets: {HexEffectTarget.self, HexEffectTarget.enemies},
        scope: HexEffectScope.target,
        intensity: 0.46,
        tintsUnit: true,
      ),
    ),
  ),
);
