import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _shineTop = -20.0;
const _shineWidth = 14.0;
const _shineHeight = 100.0;
const _shineStartLeft = -40.0;
const _shineEndLeft = 70.0;
const _shineHoldFraction = 0.55;
const _shineTiltAngle = 25 * pi / 180;

class SetChipShine extends StatelessWidget {
  const SetChipShine({required this.shineCycle, super.key});

  final Animation<double> shineCycle;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shineCycle,
      builder: (context, child) {
        final travel = ((shineCycle.value - _shineHoldFraction) / (1 - _shineHoldFraction)).clamp(0.0, 1.0);
        final left = _shineStartLeft + (_shineEndLeft - _shineStartLeft) * Curves.easeInOut.transform(travel);

        return Positioned(top: _shineTop, left: left, width: _shineWidth, height: _shineHeight, child: child!);
      },
      child: Transform.rotate(
        angle: _shineTiltAngle,
        child: ColoredBox(color: AppColors.surface100.withValues(alpha: 0.55)),
      ),
    );
  }
}
