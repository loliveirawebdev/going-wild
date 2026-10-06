import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/countdown_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/round_result_dismissed.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/widgets/round_banner/round_banner_stage.dart';

class RoundBannerOverlay extends StatelessWidget {
  const RoundBannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final matchFlowBloc = context.read<MatchFlowBloc>();

    return BlocBuilder<MatchFlowBloc, MatchFlowState>(
      builder: (context, matchFlowState) => RoundBannerStage(
        isCountingDown: matchFlowState is CountingDownMatchFlowState,
        onCountdownFinished: () => matchFlowBloc.add(const CountdownFinished()),
        onRoundResultDismissed: () => matchFlowBloc.add(const RoundResultDismissed()),
        roundResult: matchFlowState is ShowingRoundResultMatchFlowState ? matchFlowState.roundResult : null,
      ),
    );
  }
}
