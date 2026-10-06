import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _statusStyle = TextStyle(
  fontSize: 13,
  height: 18 / 13,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

const _missingStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);

class SetPresenceStatus extends StatelessWidget {
  const SetPresenceStatus({required this.setPresence, super.key});

  final SetPresence setPresence;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.setDialog;
    final reachedTierCount = setPresence.reachedTierCount;
    final missingForNextTier = setPresence.missingForNextTier;

    final (status, color) = switch (setPresence) {
      SetPresence(isComplete: true) => (translations.completeStatus, AppColors.sun600),
      SetPresence(reachedTierCount: 0) => (translations.inactiveStatus, AppColors.inkMuted),
      _ => (translations.levelStatus(level: reachedTierCount), AppColors.grass600),
    };

    return Text.rich(
      style: _statusStyle.copyWith(color: color),
      TextSpan(
        text: status,
        children: [
          if (missingForNextTier != null)
            TextSpan(
              style: _missingStyle,
              text: ' · ${translations.missingForLevel(missing: missingForNextTier, level: reachedTierCount + 1)}',
            ),
        ],
      ),
    );
  }
}
