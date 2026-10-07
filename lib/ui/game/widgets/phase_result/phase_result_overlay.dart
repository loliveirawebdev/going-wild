import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/core/widgets/pop_in.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/phase_result/phase_result_panel.dart';
import 'package:going_wild/ui/game/widgets/round_banner/victory_rays.dart';

const _victoryVeilOpacity = 0.55;
const _defeatVeilOpacity = 0.68;
const _raysSize = 620.0;
const _panelPopDuration = Duration(milliseconds: 450);

class PhaseResultOverlay extends StatelessWidget {
  const PhaseResultOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchFlowBloc, MatchFlowState>(
      builder: (context, matchFlowState) {
        final preparationState = context.watch<PreparationBloc>().state;
        if (matchFlowState is! EndedMatchFlowState || preparationState is! ReadyPreparationState) return const SizedBox.shrink();

        final matchProgress = preparationState.matchProgress;
        final phase = matchProgress.phase;
        final isVictory = matchFlowState.phaseStatus == PhaseStatus.won;
        final router = GoRouter.of(context);

        return Semantics(
          scopesRoute: true,
          explicitChildNodes: true,
          label: isVictory ? context.t.game.phaseResult.victoryTitle : context.t.game.phaseResult.defeatTitle,
          child: ColoredBox(
            color: AppColors.wood700.withValues(alpha: isVictory ? _victoryVeilOpacity : _defeatVeilOpacity),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (isVictory)
                  const OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: VictoryRays(size: _raysSize),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space4),
                  child: Center(
                    child: PopIn(
                      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : _panelPopDuration,
                      child: PhaseResultPanel(
                        isVictory: isVictory,
                        roundCount: phase.roundCount,
                        roundsReached: matchProgress.currentRoundNumber,
                        phaseName: phaseNameOf(context.t, phase),
                        phaseNumber: phaseNumberOf(phase),
                        lives: matchProgress.player.remainingLives,
                        maxLives: matchProgress.maxLives,
                        onBack: router.pop,
                        onRetry: () => router.pushReplacement(Routes.gameOf(phase.id)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
