import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:going_wild/ui/game/unit_stage/unit_stage.dart';

class UnitStageGame extends FlameGame<UnitStage> {
  UnitStageGame({required this.boardRegion}) : super(world: UnitStage());

  final Rect boardRegion;

  UnitStage get stage => world;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewfinder
      ..zoom = min(size.x / boardRegion.width, size.y / boardRegion.height)
      ..position = Vector2(boardRegion.center.dx, boardRegion.center.dy);
  }
}
