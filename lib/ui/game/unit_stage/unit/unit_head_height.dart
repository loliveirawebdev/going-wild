import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_atlas.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';

const _headHeightBeforeLoading = 300.0;

double headHeightAboveCellCenterOf(CharacterSprite sprite) {
  final headHeightInAtlas = UnitAtlas.loadedFor(sprite)?.headHeightAboveAnchor ?? _headHeightBeforeLoading;
  final flight = sprite.movement is FlyingMovement ? flightHeight : 0;
  return headHeightInAtlas * atlasToBoardScale * sprite.boardScale + flight;
}
