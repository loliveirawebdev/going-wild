import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';

class PhaseVictoryRecorder extends StatelessWidget {
  const PhaseVictoryRecorder({required this.phase, required this.child, super.key});

  final Phase phase;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchFlowBloc, MatchFlowState>(
      listenWhen: (previous, current) => current is EndedMatchFlowState && current.phaseStatus == PhaseStatus.won,
      listener: (context, state) => context.read<PhaseProgressViewModel>().markPhaseWon(phase.id),
      child: child,
    );
  }
}
