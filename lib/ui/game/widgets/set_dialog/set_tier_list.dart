import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/set_tier_lines.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_tier_row.dart';

class SetTierList extends StatelessWidget {
  const SetTierList({required this.setPresence, super.key});

  final SetPresence setPresence;

  SetTierRowState _stateOf(int tierIndex) {
    final activeTierIndex = setPresence.reachedTierCount - 1;
    if (tierIndex == activeTierIndex) return SetTierRowState.active;
    if (tierIndex < activeTierIndex) return SetTierRowState.surpassed;
    return SetTierRowState.pending;
  }

  @override
  Widget build(BuildContext context) {
    final tiers = setPresence.set.tiers;

    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var tierIndex = 0; tierIndex < tiers.length; tierIndex++)
          SetTierRow(
            state: _stateOf(tierIndex),
            memberCount: tiers[tierIndex].count,
            lines: setTierLinesOf(context.t, tiers[tierIndex]),
          ),
      ],
    );
  }
}
