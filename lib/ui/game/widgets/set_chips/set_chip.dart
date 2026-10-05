import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/ui/core/widgets/pressable.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/set_chip_celebration.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_badge.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_tone.dart';

const _pressedScaleReduction = 0.06;

class SetChip extends StatelessWidget {
  const SetChip({required this.setPresence, required this.semanticLabel, super.key, this.onPressed});

  final String semanticLabel;
  final SetPresence setPresence;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final chip = ExcludeSemantics(
      child: setPresence.isComplete
          ? SetChipCelebration(badgeBuilder: (context, shineCycle) => _buildBadge(shineCycle: shineCycle))
          : _buildBadge(),
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
    shineCycle: shineCycle,
    setId: setPresence.set.id,
    isComplete: setPresence.isComplete,
    memberCount: setPresence.presentMemberCount,
    tone: SetChipTone.ofReachedTierCount(setPresence.reachedTierCount),
  );
}
