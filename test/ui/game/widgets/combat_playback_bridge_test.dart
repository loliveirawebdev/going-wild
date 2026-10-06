import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/countdown_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fight_requested.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/round_result_dismissed.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/widgets/combat_playback_bridge.dart';

import '../../../helpers/manual_combat_playback_clock.dart';

void main() {
  testWidgets('a fight is played back, its result is shown when the playback finishes and closing it moves on to the next round', (
    tester,
  ) async {
    final clock = ManualCombatPlaybackClock();
    final matchRepository = MatchRepository();
    final combatPlaybackBloc = CombatPlaybackBloc(clock: clock);
    final matchFlowBloc = MatchFlowBloc(randomGenerator: Random(1), matchRepository: matchRepository);

    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => matchRepository,
        dispose: (matchRepository) => matchRepository.dispose(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => matchFlowBloc),
            BlocProvider(create: (context) => combatPlaybackBloc),
          ],
          child: const CombatPlaybackBridge(child: SizedBox()),
        ),
      ),
    );

    matchFlowBloc.add(const MatchStarted(phase: backyard));
    await tester.pump();
    matchFlowBloc
      ..add(const FightRequested())
      ..add(const CountdownFinished());
    await tester.pump();
    await tester.pump();

    expect(matchFlowBloc.state, isA<FightingMatchFlowState>());
    expect(combatPlaybackBloc.state, isA<PlayingCombatPlaybackState>());
    expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.fighting);

    while (combatPlaybackBloc.state is PlayingCombatPlaybackState) {
      clock.beat();
      await tester.pump();
    }

    await tester.pump();
    expect(matchFlowBloc.state, isA<ShowingRoundResultMatchFlowState>());
    expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.fighting);

    matchFlowBloc.add(const RoundResultDismissed());
    await tester.pump();
    await tester.pump();

    expect(matchFlowBloc.state, isA<PreparingMatchFlowState>());
    expect(matchRepository.currentMatchProgress!.currentRoundNumber, 2);
    expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.preparing);

    await tester.pumpWidget(const SizedBox());

    expect(matchFlowBloc.isClosed, isTrue);
    expect(combatPlaybackBloc.isClosed, isTrue);
  });
}
