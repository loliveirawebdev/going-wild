import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_flow_event.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/widgets/phase_victory_recorder.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';

import '../../../helpers/in_memory_local_storage.dart';

class FakeMatchFlowBloc extends MockBloc<MatchFlowEvent, MatchFlowState> implements MatchFlowBloc {}

Future<PhaseProgressViewModel> recordPhase(WidgetTester tester, {required List<MatchFlowState> states}) async {
  final matchFlowBloc = FakeMatchFlowBloc();
  whenListen(matchFlowBloc, Stream.fromIterable(states), initialState: const NotStartedMatchFlowState());
  final progressViewModel = PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: InMemoryLocalStorage()));

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<MatchFlowBloc>.value(value: matchFlowBloc),
        BlocProvider.value(value: progressViewModel),
      ],
      child: const PhaseVictoryRecorder(phase: pondEdge, child: SizedBox()),
    ),
  );
  await tester.pump();

  return progressViewModel;
}

void main() {
  testWidgets('winning the match marks its phase as won', (tester) async {
    final progressViewModel = await recordPhase(tester, states: [const EndedMatchFlowState(phaseStatus: PhaseStatus.won)]);
    expect(progressViewModel.state.hasWon(pondEdge.id), isTrue);
  });

  testWidgets('losing the match leaves the progress untouched', (tester) async {
    final progressViewModel = await recordPhase(tester, states: [const EndedMatchFlowState(phaseStatus: PhaseStatus.lost)]);
    expect(progressViewModel.state.wonPhaseIds, isEmpty);
  });
}
