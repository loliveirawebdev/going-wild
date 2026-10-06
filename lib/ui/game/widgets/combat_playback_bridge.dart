import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_started.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_playback_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner_view_model.dart';

class CombatPlaybackBridge extends StatelessWidget {
  const CombatPlaybackBridge({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MatchFlowBloc, MatchFlowState>(
          listener: _startPlayback,
          listenWhen: (previous, current) => previous is! FightingMatchFlowState && current is FightingMatchFlowState,
        ),
        BlocListener<CombatPlaybackBloc, CombatPlaybackState>(
          listener: _showRoundResult,
          listenWhen: (previous, current) => previous is! FinishedCombatPlaybackState && current is FinishedCombatPlaybackState,
        ),
        BlocListener<RoundBannerViewModel, RoundBanner?>(
          listener: (context, state) => context.read<MatchFlowBloc>().add(const FightingStarted()),
          listenWhen: (previous, current) => previous is CountdownRoundBanner && current == null,
        ),
        BlocListener<RoundBannerViewModel, RoundBanner?>(
          listener: (context, state) => context.read<MatchFlowBloc>().add(const FightingPlaybackFinished()),
          listenWhen: (previous, current) => previous is ResultRoundBanner && current == null,
        ),
      ],
      child: child,
    );
  }

  void _startPlayback(BuildContext context, MatchFlowState state) {
    if (state is! FightingMatchFlowState) return;
    final ticksPerSecond = state.matchProgressAfterFight.phase.engines.combatEngine.rules.ticksPerSecond;
    final combatPlaybackStarted = CombatPlaybackStarted(combatHistory: state.combatResult.history, ticksPerSecond: ticksPerSecond);

    context.read<CombatPlaybackBloc>().add(combatPlaybackStarted);
  }

  void _showRoundResult(BuildContext context, CombatPlaybackState state) {
    final matchFlowState = context.read<MatchFlowBloc>().state;
    final fightingMatchProgress = context.read<MatchRepository>().currentMatchProgress;
    if (matchFlowState is! FightingMatchFlowState || fightingMatchProgress == null) return;

    final matchProgressAfterFight = matchFlowState.matchProgressAfterFight;
    final levelEngine = matchProgressAfterFight.phase.engines.levelEngine;

    context.read<RoundBannerViewModel>().showResult(
      ResultRoundBanner(
        isVictory: !matchFlowState.combatResult.isLost,
        roundNumber: fightingMatchProgress.currentRoundNumber,
        coinsGained: matchProgressAfterFight.player.coins - fightingMatchProgress.player.coins,
        livesLost: fightingMatchProgress.player.remainingLives - matchProgressAfterFight.player.remainingLives,
        experienceGained: matchProgressAfterFight.isInProgress ? levelEngine.experienceForRound(matchProgress: matchProgressAfterFight) : 0,
      ),
    );
  }
}
