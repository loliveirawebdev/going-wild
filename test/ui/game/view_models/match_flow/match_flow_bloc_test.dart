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
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_playback_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';

const seed = 1;
const singleWavePhase = Phase(id: PhaseId('single_wave'), engines: basicPhaseEngines, waves: [backyardWave1]);

void main() {
  late MatchRepository matchRepository;

  setUp(() => matchRepository = MatchRepository());
  tearDown(() => matchRepository.dispose());

  MatchFlowBloc buildMatchFlowBloc() => MatchFlowBloc(randomGenerator: Random(seed), matchRepository: matchRepository);

  void storeStartedMatch(Phase phase) => matchRepository.replaceMatchProgress(startMatch(phase, randomGenerator: Random(seed)));

  FightingMatchFlowState fightingStateOfStoredMatch() {
    final startedFight = startFight(matchRepository.currentMatchProgress!, recordsHistory: true);
    matchRepository.replaceMatchProgress(startedFight.fightingMatchProgress);

    return FightingMatchFlowState(combatResult: startedFight.combatResult, matchProgressAfterFight: startedFight.matchProgressAfterFight);
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

  group('fighting', () {
    blocTest<MatchFlowBloc, MatchFlowState>(
      'starting a fight stores the match as fighting and holds the result until the playback finishes',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: () => const PreparingMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingStarted()),
      expect: () => [
        isA<FightingMatchFlowState>()
            .having((state) => state.combatResult.history.entries, 'history', isNotEmpty)
            .having((state) => state.matchProgressAfterFight.currentRoundNumber, 'round after the fight', 2),
      ],
      verify: (_) {
        expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.fighting);
        expect(matchRepository.currentMatchProgress!.currentRoundNumber, 1);
      },
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'fighting before the match starts is ignored',
      build: buildMatchFlowBloc,
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingStarted()),
      expect: () => <MatchFlowState>[],
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'a second fight is ignored while fighting',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: fightingStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingStarted()),
      expect: () => <MatchFlowState>[],
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'when the fight playback finishes the match after the fight is stored and the next round is prepared',
      setUp: () => storeStartedMatch(backyard),
      build: buildMatchFlowBloc,
      seed: fightingStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingPlaybackFinished()),
      expect: () => [isA<PreparingMatchFlowState>()],
      verify: (_) {
        expect(matchRepository.currentMatchProgress!.currentRoundNumber, 2);
        expect(matchRepository.currentMatchProgress!.roundStage, RoundStage.preparing);
      },
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'when the playback of the last round finishes the match ends',
      setUp: () => storeStartedMatch(singleWavePhase),
      build: buildMatchFlowBloc,
      seed: fightingStateOfStoredMatch,
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingPlaybackFinished()),
      expect: () => [isA<EndedMatchFlowState>().having((state) => state.phaseStatus, 'status', isNot(PhaseStatus.inProgress))],
    );

    blocTest<MatchFlowBloc, MatchFlowState>(
      'a finished playback while preparing is ignored',
      build: buildMatchFlowBloc,
      seed: () => const PreparingMatchFlowState(),
      act: (matchFlowBloc) => matchFlowBloc.add(const FightingPlaybackFinished()),
      expect: () => <MatchFlowState>[],
    );
  });
}
