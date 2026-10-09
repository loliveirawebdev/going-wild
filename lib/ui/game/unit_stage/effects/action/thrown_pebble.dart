import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _flightSeconds = 0.26;
const _pebbleRadius = 4.5;
const _arcHeightToDistance = 0.18;

class ThrownPebble extends Component {
  ThrownPebble({required this.from, required this.to});

  final Offset to;
  final Offset from;
  final _paint = Paint()..color = AppColors.ink;
  double _seconds = 0;

  @override
  void update(double dt) {
    _seconds += dt;
    if (_seconds >= _flightSeconds) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = min(1.0, _seconds / _flightSeconds);
    final lift = 4 * progress * (1 - progress) * (to - from).distance * _arcHeightToDistance;
    canvas.drawCircle(Offset.lerp(from, to, progress)! - Offset(0, lift), _pebbleRadius, _paint);
  }
}
