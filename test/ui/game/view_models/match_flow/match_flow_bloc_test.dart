import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/content/phase/backyard/wave_1.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/round/round_result_of.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_playback_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/countdown_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fight_requested.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/round_result_dismissed.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';

import '../../../../helpers/in_memory_local_storage.dart';

const seed = 1;
const singleWavePhase = Phase(id: PhaseId('single_wave'), engines: basicPhaseEngines, waves: [backyardWave1]);

PhaseProgressViewModel testPhaseProgress() =>
    PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: InMemoryLocalStorage()));

void main() {
  late MatchRepository matchRepository;

  late PhaseProgressViewModel phaseProgress;

  setUp(() {
    matchRepository = MatchRepository();
    phaseProgress = testPhaseProgress();
  });
  tearDown(() => matchRepository.dispose());

  MatchFlowBloc buildMatchFlowBloc() =>
      MatchFlowBloc(randomGenerator: Random(seed), matchRepository: matchRepository, phaseProgress: phaseProgress);

  void storeStartedMatch(Phase phase) => matchRepository.replaceMatchProgress(startMatch(phase, randomGenerator: Random(seed)));

  FightingMatchFlowState fightingStateOfStoredMatch() {
    final matchProgress = matchRepository.currentMatchProgress!;
    final startedFight = startFight(matchProgress, recordsHistory: true);
    matchRepository.replaceMatchProgress(startedFight.fightingMatchProgress);

    return FightingMatchFlowState(
      matchProgressBeforeFight: matchProgress,
      combatResult: startedFight.combatResult,
      matchProgressAfterFight: startedFight.matchProgressAfterFight,
    );
  }

  ShowingRoundResultMatchFlowState roundResultStateOfStoredMatch() {
    final fightingState = fightingStateOfStoredMatch();

    return ShowingRoundResultMatchFlowState(
      matchProgressAfterFight: fightingState.matchProgressAfterFight,
      roundResult: roundResultOf(
        combatResult: fightingState.combatResult,
        matchProgressAfterFight: fightingState.matchProgressAfterFight,
        matchProgressBeforeFight: fightingState.matchProgressBeforeFight,
      ),
    );
  }

  group('starting', () {
    test('the flow waits for the match to start', () {
      expect(buildMatchFlowBloc().state, isA<NotStartedMatchFlowState>());
    });

    blocTest<MatchFlowBloc, MatchFlowState>(
      'starting the match stores the first round of the chosen phase and prepares it',
      build: buildMatchFlowBloc,
      act: (matchFlowBloc) => matchFlowBloc.add(const MatchStarted(phase: backyard)),
      expect: () => [isA<PreparingMatchFlowState>()],
      verify: (_) {
        expect(matchRepository.currentMatchProgress!.phase, same(backyard));
        expect(matchRepository.currentMatchProgress!.currentRoundNumber, 1);
      },
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'a match already started does not start again',
      build: buildMatchFlowBloc,
      seed: () => const PreparingMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const MatchStarted(phase: backyard)),
      expect: () => <MatchFlowState>[],
    );
  });

  group('counting down', () {
    blocTest<MatchFlowBloc, MatchFlowState>(
      'asking to fight while preparing starts the countdown without touching the match yet',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: () => const PreparingMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const FightRequested()),
      expect: () => [isA<CountingDownMatchFlowState>()],
      verify: (_) => expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.preparing),
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'asking to fight before the match starts or while a countdown runs is ignored',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: () => const CountingDownMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const FightRequested()),
      expect: () => <MatchFlowState>[],
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'a countdown that ends when the fight can no longer start goes back to preparing instead of throwing',
      setUp: () {
        storeStartedMatch(backyard);
        final matchProgress = matchRepository.currentMatchProgress!;
        matchRepository.replaceMatchProgress(matchProgress.createCopyWith(roundStage: RoundStage.fighting));
      },
      build: buildMatchFlowBloc,
      seed: () => const CountingDownMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const CountdownFinished()),
      expect: () => [isA<PreparingMatchFlowState>()],
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'a countdown that finishes outside the countdown is ignored',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: () => const PreparingMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const CountdownFinished()),
      expect: () => <MatchFlowState>[],
    );
  });

  group('fighting', () {
    blocTest<MatchFlowBloc, MatchFlowState>(
      'the end of the countdown stores the match as fighting and holds what comes after until the playback finishes',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: () => const CountingDownMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const CountdownFinished()),
      expect: () => [
        isA<FightingMatchFlowState>()
            .having((state) => state.combatResult.history.entries, 'history', isNotEmpty)
            .having((state) => state.matchProgressBeforeFight.currentRoundNumber, 'round before the fight', 1)
            .having((state) => state.matchProgressAfterFight.currentRoundNumber, 'round after the fight', 2),
      ],
      verify: (_) {
        expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.fighting);
        expect(matchRepository.currentMatchProgress!.currentRoundNumber, 1);
      },
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'when the playback finishes the round result is shown while the match still holds the fight',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: fightingStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingPlaybackFinished()),
      expect: () => [
        isA<ShowingRoundResultMatchFlowState>().having((state) => state.roundResult.roundNumber, 'round of the result', 1),
      ],
      verify: (_) => expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.fighting),
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'a finished playback while preparing is ignored',
      build: buildMatchFlowBloc,
      seed: () => const PreparingMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingPlaybackFinished()),
      expect: () => <MatchFlowState>[],
    );
  });

  group('round result', () {
    blocTest<MatchFlowBloc, MatchFlowState>(
      'closing the result stores the match after the fight and prepares the next round',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: roundResultStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc.add(const RoundResultDismissed()),
      expect: () => [isA<PreparingMatchFlowState>()],
      verify: (_) {
        expect(matchRepository.currentMatchProgress!.currentRoundNumber, 2);
        expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.preparing);
      },
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'closing the result of the last round ends the match',
      setUp: () => storeStartedMatch(singleWavePhase),
      build: buildMatchFlowBloc,
      seed: roundResultStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc.add(const RoundResultDismissed()),
      expect: () => [isA<EndedMatchFlowState>().having((state) => state.phaseStatus, 'status', isNot(PhaseStatus.inProgress))],
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'closing a result twice or outside the result is ignored',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: roundResultStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc
        ..add(const RoundResultDismissed())
        ..add(const RoundResultDismissed()),
      expect: () => [isA<PreparingMatchFlowState>()],
    );
  });

  group('phase progress', () {
    blocTest<MatchFlowBloc, MatchFlowState>(
      'closing the result of a won match records the phase as won',
      setUp: () => storeStartedMatch(singleWavePhase),
      build: buildMatchFlowBloc,
      seed: () {
        final roundResultState = roundResultStateOfStoredMatch();
        return ShowingRoundResultMatchFlowState(
          roundResult: roundResultState.roundResult,
          matchProgressAfterFight: roundResultState.matchProgressAfterFight.createCopyWith(status: PhaseStatus.won),
        );
      },
      act: (matchFlowBloc) => matchFlowBloc.add(const RoundResultDismissed()),
      expect: () => [isA<EndedMatchFlowState>().having((state) => state.phaseStatus, 'status', PhaseStatus.won)],
      verify: (_) => expect(phaseProgress.state.hasWon(singleWavePhase.id), isTrue),
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'closing the result of a lost match leaves the progress untouched',
      setUp: () => storeStartedMatch(singleWavePhase),
      build: buildMatchFlowBloc,
      seed: () {
        final roundResultState = roundResultStateOfStoredMatch();
        return ShowingRoundResultMatchFlowState(
          roundResult: roundResultState.roundResult,
          matchProgressAfterFight: roundResultState.matchProgressAfterFight.createCopyWith(status: PhaseStatus.lost),
        );
      },
      act: (matchFlowBloc) => matchFlowBloc.add(const RoundResultDismissed()),
      expect: () => [isA<EndedMatchFlowState>()],
      verify: (_) => expect(phaseProgress.state.wonPhaseIds, isEmpty),
    );
  });
}
