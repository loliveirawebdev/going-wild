import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/stat_counter.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/experience_pill.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_shelf.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/team_count_pill.dart';

const _itemSpacing = 5.0;

class MatchInfoShelf extends StatelessWidget {
  const MatchInfoShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, state) {
        if (state is! ReadyPreparationState) return const SizedBox.shrink();
        final matchProgress = state.matchProgress;
        final coins = matchProgress.player.coins;

        return MatchShelf(
          child: Row(
            spacing: _itemSpacing,
            children: [
              Expanded(child: ExperiencePill(matchProgress: matchProgress)),
              TeamCountPill(
                teamSize: matchProgress.teamSize,
                teamLimit: matchProgress.teamLimit,
              ),
              StatCounter(
                icon: GameIcon.gold,
                value: coins,
                semanticLabel: context.t.game.infoShelf.coinsLabel(coins: coins),
              ),
            ],
          ),
        );
      },
    );
  }
}
