import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/round/round_result_of.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/countdown_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fight_requested.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_playback_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_flow_event.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/round_result_dismissed.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';

class MatchFlowBloc extends Bloc<MatchFlowEvent, MatchFlowState> {
  final Random _randomGenerator;
  final MatchRepository _matchRepository;
  final PhaseProgressViewModel _phaseProgress;

  MatchFlowBloc({required this._randomGenerator, required this._matchRepository, required this._phaseProgress})
    : super(const NotStartedMatchFlowState()) {
    on<MatchStarted>(_onMatchStarted);
    on<FightRequested>(_onFightRequested);
    on<CountdownFinished>(_onCountdownFinished);
    on<RoundResultDismissed>(_onRoundResultDismissed);
    on<FightingPlaybackFinished>(_onFightingPlaybackFinished);
  }

  void _onMatchStarted(MatchStarted event, Emitter<MatchFlowState> emit) {
    if (state is! NotStartedMatchFlowState) return;
    _matchRepository.replaceMatchProgress(startMatch(event.phase, randomGenerator: _randomGenerator));
    emit(const PreparingMatchFlowState());
  }

  void _onFightRequested(FightRequested event, Emitter<MatchFlowState> emit) {
    final matchProgress = _matchRepository.currentMatchProgress;
    if (state is! PreparingMatchFlowState || matchProgress == null || checkStartingFight(matchProgress) != null) return;
    emit(const CountingDownMatchFlowState());
  }

  void _onCountdownFinished(CountdownFinished event, Emitter<MatchFlowState> emit) {
    final matchProgress = _matchRepository.currentMatchProgress;
    if (state is! CountingDownMatchFlowState || matchProgress == null) return;

    if (checkStartingFight(matchProgress) != null) {
      emit(const PreparingMatchFlowState());
      return;
    }

    final startedFight = startFight(matchProgress, recordsHistory: true);
    _matchRepository.replaceMatchProgress(startedFight.fightingMatchProgress);

    emit(
      FightingMatchFlowState(
        matchProgressBeforeFight: matchProgress,
        combatResult: startedFight.combatResult,
        matchProgressAfterFight: startedFight.matchProgressAfterFight,
      ),
    );
  }

  void _onFightingPlaybackFinished(FightingPlaybackFinished event, Emitter<MatchFlowState> emit) {
    final currentState = state;
    if (currentState is! FightingMatchFlowState) return;

    emit(
      ShowingRoundResultMatchFlowState(
        matchProgressAfterFight: currentState.matchProgressAfterFight,
        roundResult: roundResultOf(
          combatResult: currentState.combatResult,
          matchProgressAfterFight: currentState.matchProgressAfterFight,
          matchProgressBeforeFight: currentState.matchProgressBeforeFight,
        ),
      ),
    );
  }

  void _onRoundResultDismissed(RoundResultDismissed event, Emitter<MatchFlowState> emit) {
    final currentState = state;
    if (currentState is! ShowingRoundResultMatchFlowState) return;
    final matchProgressAfterFight = currentState.matchProgressAfterFight;

    _matchRepository.replaceMatchProgress(matchProgressAfterFight);

    if (matchProgressAfterFight.isInProgress) {
      emit(const PreparingMatchFlowState());
      return;
    }

    if (matchProgressAfterFight.status == PhaseStatus.won) _phaseProgress.markPhaseWon(matchProgressAfterFight.phase.id);
    emit(EndedMatchFlowState(phaseStatus: matchProgressAfterFight.status));
  }
}
