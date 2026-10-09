import 'dart:ui';

import 'package:flame/components.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';

const _shadowWidth = 64.0;
const _shadowHeight = 20.0;
const _shadowOpacity = 0.24;
const _flyingShadowOpacity = 0.16;
const _shadowBlur = MaskFilter.blur(BlurStyle.normal, 3);

class UnitShadow extends Component {
  UnitShadow({required this.unit});

  final UnitSprite unit;
  final _paint = Paint()..maskFilter = _shadowBlur;

  @override
  void render(Canvas canvas) {
    final opacity = unit.groundOpacity;
    if (opacity <= 0 || !unit.isLoaded) return;

    final scale = unit.sprite.boardScale;
    final baseOpacity = unit.sprite.movement is FlyingMovement ? _flyingShadowOpacity : _shadowOpacity;
    _paint.color = Color.fromRGBO(0, 0, 0, baseOpacity * opacity);

    canvas.drawOval(
      Rect.fromCenter(center: unit.stagePoint, width: _shadowWidth * scale, height: _shadowHeight * scale),
      _paint,
    );
  }
}
