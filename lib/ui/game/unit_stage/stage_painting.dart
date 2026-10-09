import 'dart:ui';

import 'package:flame/components.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';

class StagePainting extends Component {
  StagePainting(this._paint, {this.inFrontOf});

  final UnitSprite? inFrontOf;
  final void Function(Canvas canvas) _paint;

  @override
  void update(double dt) {
    if (inFrontOf case final unit?) priority = unit.priority + 1;
  }

  @override
  void render(Canvas canvas) => _paint(canvas);
}
