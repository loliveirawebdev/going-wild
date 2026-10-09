import 'package:going_wild/domain/models/character/sprite/ability_visuals.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';

class CharacterSprite {
  const CharacterSprite({
    required this.atlasPath,
    required this.boardScale,
    required this.movement,
    required this.abilityVisuals,
    this.mirrorsAbilityPose = true,
  });

  final String atlasPath;
  final double boardScale;
  final SpriteMovement movement;
  final AbilityVisuals abilityVisuals;
  final bool mirrorsAbilityPose;
}
