import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/exit_match_dialog.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/lives_counter.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/round_pill.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/top_bar_pill.dart';

const _heartSize = 18.0;
const _itemSpacing = 5.0;

class MatchTopBar extends StatelessWidget {
  const MatchTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.space3, safeAreaTop + AppSpacing.space2, AppSpacing.space3, 0),
      child: BlocBuilder<PreparationBloc, PreparationState>(
        builder: (context, state) => Row(
          spacing: _itemSpacing,
          children: [
            if (state is ReadyPreparationState) ..._buildMatchPills(context, state.matchProgress),
            const Spacer(),
            RoundIconButton(
              glyph: InterfaceGlyph.exit,
              size: RoundIconButtonSize.small,
              onPressed: () => presentExitMatchDialog(context, onExit: GoRouter.of(context).pop),
              label: context.t.game.topBar.exitButton,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMatchPills(BuildContext context, MatchProgress matchProgress) {
    final maxLives = matchProgress.maxLives;
    final translations = context.t.game.topBar;
    final lives = matchProgress.player.remainingLives;

    return [
      TopBarPill(
        horizontalPadding: 8,
        edgeColor: AppColors.surface400,
        fillColor: AppColors.surface100.withValues(alpha: 0.92),
        child: LivesCounter(
          lives: lives,
          maxLives: maxLives,
          heartSize: _heartSize,
          semanticLabel: translations.lives(lives: lives, maxLives: maxLives),
        ),
      ),
      RoundPill(
        label: translations.round,
        roundCount: matchProgress.phase.roundCount,
        roundNumber: matchProgress.currentRoundNumber,
      ),
    ];
  }
}
