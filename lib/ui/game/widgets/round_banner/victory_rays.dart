import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _rayWidth = 10 * pi / 180;
const _rayStep = 24 * pi / 180;
const _turnDuration = Duration(seconds: 14);

class VictoryRays extends StatefulWidget {
  final double size;
  const VictoryRays({super.key, this.size = 420});

  @override
  State<VictoryRays> createState() => _VictoryRaysState();
}

class _VictoryRaysState extends State<VictoryRays> with SingleTickerProviderStateMixin {
  late final _turnController = AnimationController(vsync: this, duration: _turnDuration);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _turnController.stop();
      return;
    }
    _turnController.repeat();
  }

  @override
  void dispose() {
    _turnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.square(
        dimension: widget.size,
        child: RotationTransition(
          turns: _turnController,
          child: const CustomPaint(painter: _RaysPainter()),
        ),
      ),
    );
  }
}

class _RaysPainter extends CustomPainter {
  const _RaysPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rayPaint = Paint()
      ..shader = RadialGradient(
        stops: const [0.3, 1],
        colors: [AppColors.sun400.withValues(alpha: 0.55), AppColors.sun400.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    for (var startAngle = 0.0; startAngle < 2 * pi; startAngle += _rayStep) {
      final ray = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(Rect.fromCircle(center: center, radius: radius), startAngle, _rayWidth, false)
        ..close();
      canvas.drawPath(ray, rayPaint);
    }
  }

  @override
  bool shouldRepaint(_RaysPainter oldDelegate) => false;
}
