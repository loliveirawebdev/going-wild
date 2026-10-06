import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/spark_painter.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/twinkling_spark.dart';

const _twinkleDuration = Duration(milliseconds: 1400);
const _sparkPainter = SparkPainter(fillColor: AppColors.surface100, strokeColor: AppColors.sun600);

class VictorySparks extends StatefulWidget {
  final Widget child;
  const VictorySparks({required this.child, super.key});

  @override
  State<VictorySparks> createState() => _VictorySparksState();
}

class _VictorySparksState extends State<VictorySparks> with SingleTickerProviderStateMixin {
  late final _twinkleController = AnimationController(vsync: this, duration: _twinkleDuration);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _twinkleController.stop();
      return;
    }
    _twinkleController.repeat();
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final twinkle = MediaQuery.disableAnimationsOf(context) ? null : _twinkleController;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final placements = [
          SparkPlacement(size: 22, cycleOffset: 0, left: width * 0.04, top: -width * 0.04),
          SparkPlacement(size: 28, cycleOffset: 0.3 / 1.4, right: width * 0.06, top: -width * 0.05),
          SparkPlacement(size: 16, cycleOffset: 0.6 / 1.4, left: width * 0.14, bottom: -width * 0.035),
          SparkPlacement(size: 18, cycleOffset: 0.9 / 1.4, right: width * 0.16, bottom: -width * 0.03),
        ];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            for (final placement in placements)
              Positioned(
                top: placement.top,
                left: placement.left,
                right: placement.right,
                bottom: placement.bottom,
                child: TwinklingSpark(placement: placement, sparkCycle: twinkle, painter: _sparkPainter),
              ),
          ],
        );
      },
    );
  }
}
