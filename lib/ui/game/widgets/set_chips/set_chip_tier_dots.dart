import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_tone.dart';

const _tierDotSize = 9.0;

class SetChipTierDots extends StatelessWidget {
  const SetChipTierDots({required this.tierCount, required this.reachedTierCount, super.key});

  final int tierCount;
  final int reachedTierCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var tierIndex = 0; tierIndex < tierCount; tierIndex++)
          _TierDot(tone: tierIndex < reachedTierCount ? SetChipTone.ofReachedTierCount(tierIndex + 1) : SetChipTone.inactive),
      ],
    );
  }
}

class _TierDot extends StatelessWidget {
  const _TierDot({required this.tone});

  final SetChipTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _tierDotSize,
      height: _tierDotSize,
      decoration: BoxDecoration(
        color: tone.faceColor,
        borderRadius: AppRadius.pill,
        border: Border.all(color: tone.edgeColor, width: AppBorderWidth.thin),
      ),
    );
  }
}
