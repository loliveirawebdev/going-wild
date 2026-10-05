import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/zoom.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_semantic_label.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_dialog.dart';

const _chipScale = 0.76;
const _chipSpacing = 6.0;
const _celebrationMargin = 6.0;

int _compareByHighlight(SetPresence first, SetPresence second) {
  if (first.isComplete != second.isComplete) return first.isComplete ? -1 : 1;
  if (first.reachedTierCount != second.reachedTierCount) return second.reachedTierCount - first.reachedTierCount;
  if (first.presentMemberCount != second.presentMemberCount) return second.presentMemberCount - first.presentMemberCount;
  return first.set.id.value.compareTo(second.set.id.value);
}

class SetChipRow extends StatelessWidget {
  const SetChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, state) {
        if (state is! ReadyPreparationState) return const SizedBox.shrink();
        final setPresences = _sortedSetPresencesOf(state.matchProgress);
        if (setPresences.isEmpty) return const SizedBox.shrink();

        return SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(AppSpacing.space3, AppSpacing.space4, AppSpacing.space3, AppSpacing.space3),
          child: Row(
            spacing: _chipSpacing,
            children: [
              for (final setPresence in setPresences)
                Zoom(
                  scale: _chipScale,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: setPresence.isComplete ? _celebrationMargin : 0),
                    child: SetChip(
                      setPresence: setPresence,
                      semanticLabel: setChipSemanticLabelOf(context, setPresence),
                      onPressed: () => presentSetDialog(context, setPresence: setPresence),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<SetPresence> _sortedSetPresencesOf(MatchProgress matchProgress) {
    final boardCharacters = [for (final placement in matchProgress.playerRoster.placements) placement.characterCopy.character];
    return matchProgress.phase.engines.setEngine.setPresences(boardCharacters)..sort(_compareByHighlight);
  }
}
