import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/sprite/ability_visuals.dart';
import 'package:going_wild/domain/models/character/sprite/action_effect.dart';
import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_color.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/mana_full_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';

const Character alligator = Character(
  id: CharacterId('alligator'),
  role: Role.tank,
  rarity: Rarity.rare,

  ability: Ability(
    trigger: ManaFullTrigger(),

    effects: [
      DamageEffect(
        target: FocusTarget(),
        value: StarValues(star1: 200, star2: 300, star3: 450),
      ),

      StunEffect(
        target: FocusTarget(),
        seconds: StarValues(star1: 1.5, star2: 2, star3: 2.5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 2,
    Stat.damage: 1,
    Stat.armor: 2,
    Stat.attackSpeed: 0.6,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),

  sprite: CharacterSprite(
    atlasPath: 'lib/content/character/enemies/alligator/atlas.webp',
    boardScale: 1.27,
    movement: WalkingMovement(),
    abilityVisuals: AbilityVisuals(
      actionEffects: [
        StunActionEffect(color: SpriteColor(0xFFFFD23C)),
      ],
    ),
  ),
);
