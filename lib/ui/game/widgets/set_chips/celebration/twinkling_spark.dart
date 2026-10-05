import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/eased_ping_pong.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/spark_painter.dart';

const _sparkTiltAngle = 20 * pi / 180;

class SparkPlacement {
  const SparkPlacement({required this.size, required this.cycleOffset, this.top, this.left, this.right, this.bottom});

  final double size;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double cycleOffset;
}

class TwinklingSpark extends StatelessWidget {
  const TwinklingSpark({required this.placement, required this.sparkCycle, super.key});

  final SparkPlacement placement;
  final Animation<double>? sparkCycle;

  @override
  Widget build(BuildContext context) {
    final sparkImage = SizedBox.square(
      dimension: placement.size,
      child: const CustomPaint(painter: SparkPainter()),
    );
    final sparkCycle = this.sparkCycle;
    if (sparkCycle == null) return sparkImage;

    return AnimatedBuilder(
      animation: sparkCycle,
      child: sparkImage,
      builder: (context, child) {
        final twinkle = easedPingPongOf((sparkCycle.value - placement.cycleOffset) % 1);

        return Opacity(
          opacity: 0.85 + 0.15 * twinkle,
          child: Transform.rotate(
            angle: _sparkTiltAngle * twinkle,
            child: Transform.scale(scale: 0.75 + 0.35 * twinkle, child: child),
          ),
        );
      },
    );
  }
}
