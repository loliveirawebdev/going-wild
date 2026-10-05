import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _ringInset = 5.0;
const _ringEdgeWidth = 2.0;
const _ringPulseScale = 0.07;
const _ringRadius = BorderRadius.all(Radius.circular(17 + _ringEdgeWidth));

class CelebrationRing extends StatelessWidget {
  const CelebrationRing({required this.pulse, super.key});

  final double pulse;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -_ringInset,
      left: -_ringInset,
      right: -_ringInset,
      bottom: -_ringInset,
      child: Transform.scale(
        scale: 1 + _ringPulseScale * pulse,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.sun400,
            borderRadius: _ringRadius,
            border: Border.fromBorderSide(BorderSide(color: AppColors.sun600, width: _ringEdgeWidth)),
          ),
        ),
      ),
    );
  }
}
