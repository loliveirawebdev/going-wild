import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_playback_finished.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/fighting_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_flow_event.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_started.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';

class MatchFlowBloc extends Bloc<MatchFlowEvent, MatchFlowState> {
  final Random _randomGenerator;
  final MatchRepository _matchRepository;

  MatchFlowBloc({required this._randomGenerator, required this._matchRepository}) : super(const NotStartedMatchFlowState()) {
    on<MatchStarted>(_onMatchStarted);
    on<FightingStarted>(_onFightingStarted);
    on<FightingPlaybackFinished>(_onFightingPlaybackFinished);
  }

  void _onMatchStarted(MatchStarted event, Emitter<MatchFlowState> emit) {
    if (state is! NotStartedMatchFlowState) return;
    _matchRepository.replaceMatchProgress(startMatch(event.phase, randomGenerator: _randomGenerator));
    emit(const PreparingMatchFlowState());
  }

  void _onFightingStarted(FightingStarted event, Emitter<MatchFlowState> emit) {
    final matchProgress = _matchRepository.currentMatchProgress;
    if (state is! PreparingMatchFlowState || matchProgress == null || checkStartingFight(matchProgress) != null) return;
    final startedFight = startFight(matchProgress, recordsHistory: true);

    _matchRepository.replaceMatchProgress(startedFight.fightingMatchProgress);
    emit(FightingMatchFlowState(combatResult: startedFight.combatResult, matchProgressAfterFight: startedFight.matchProgressAfterFight));
  }

  void _onFightingPlaybackFinished(FightingPlaybackFinished event, Emitter<MatchFlowState> emit) {
    final currentState = state;
    if (currentState is! FightingMatchFlowState) return;
    final matchProgressAfterFight = currentState.matchProgressAfterFight;

    _matchRepository.replaceMatchProgress(matchProgressAfterFight);

    if (matchProgressAfterFight.isInProgress) {
      emit(const PreparingMatchFlowState());
      return;
    }

    emit(EndedMatchFlowState(phaseStatus: matchProgressAfterFight.status));
  }
}
