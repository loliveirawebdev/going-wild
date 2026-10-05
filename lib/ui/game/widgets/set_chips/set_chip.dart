import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/ui/core/widgets/pressable.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/set_chip_celebration.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_badge.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_tier_dots.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_tone.dart';

const _pressedScaleReduction = 0.06;

class SetChip extends StatelessWidget {
  const SetChip({
    required this.setId,
    required this.tierCounts,
    required this.semanticLabel,
    required this.presentMemberCount,
    super.key,
    this.onPressed,
  });

  final SetId setId;
  final List<int> tierCounts;
  final String semanticLabel;
  final int presentMemberCount;
  final VoidCallback? onPressed;

  int get reachedTierCount => tierCounts.where((tierCount) => tierCount <= presentMemberCount).length;
  bool get isComplete => reachedTierCount > 0 && reachedTierCount == tierCounts.length;

  @override
  Widget build(BuildContext context) {
    final chip = ExcludeSemantics(
      child: Column(
        spacing: 7,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isComplete) SetChipCelebration(badgeBuilder: (context, shineCycle) => _buildBadge(shineCycle: shineCycle)) else _buildBadge(),
          SetChipTierDots(tierCount: tierCounts.length, reachedTierCount: reachedTierCount),
        ],
      ),
    );

    final onPressed = this.onPressed;
    if (onPressed == null) return Semantics(container: true, label: semanticLabel, child: chip);

    return Pressable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      builder: (context, pressedAmount, child) => Transform.scale(scale: 1 - _pressedScaleReduction * pressedAmount, child: child),
      child: chip,
    );
  }

  Widget _buildBadge({Animation<double>? shineCycle}) => SetChipBadge(
    setId: setId,
    isComplete: isComplete,
    shineCycle: shineCycle,
    memberCount: presentMemberCount,
    tone: SetChipTone.ofReachedTierCount(reachedTierCount),
  );
}
