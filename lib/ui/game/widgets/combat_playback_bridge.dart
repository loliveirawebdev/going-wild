import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_started.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_playback_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';

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
          listener: (context, state) => context.read<MatchFlowBloc>().add(const FightingPlaybackFinished()),
          listenWhen: (previous, current) => previous is! FinishedCombatPlaybackState && current is FinishedCombatPlaybackState,
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
}
