import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_clock.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_event.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_speed_changed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_started.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';

class CombatPlaybackBloc extends Bloc<CombatPlaybackEvent, CombatPlaybackState> {
  final CombatPlaybackClock _clock;

  CombatPlaybackBloc({required this._clock, CombatPlaybackSpeed initialSpeed = CombatPlaybackSpeed.normal})
    : super(IdleCombatPlaybackState(speed: initialSpeed)) {
    on<CombatPlaybackSpeedChanged>(_onCombatPlaybackSpeedChanged);
    on<CombatPlaybackStarted>(_onCombatPlaybackStarted);
  }

  void _onCombatPlaybackSpeedChanged(CombatPlaybackSpeedChanged event, Emitter<CombatPlaybackState> emit) {
    emit(state.createCopyWithSpeed(event.speed));
  }

  Future<void> _onCombatPlaybackStarted(CombatPlaybackStarted event, Emitter<CombatPlaybackState> emit) async {
    if (state is PlayingCombatPlaybackState) return;
    final combatReplay = CombatReplay.fromHistory(event.combatHistory);
    final beatInterval = Duration(microseconds: (Duration.microsecondsPerSecond / event.ticksPerSecond).round());

    emit(
      PlayingCombatPlaybackState(
        currentTick: 0,
        previousTick: 0,
        speed: state.speed,
        combatReplay: combatReplay,
      ),
    );

    await emit.onEach(
      _clock.beatEvery(beatInterval).takeWhile((_) => state is PlayingCombatPlaybackState),
      onData: (_) => _advanceOneBeat(emit),
    );
  }

  void _advanceOneBeat(Emitter<CombatPlaybackState> emit) {
    final currentState = state;
    if (currentState is! PlayingCombatPlaybackState) return;

    if (currentState.isAtFinalTick) {
      emit(
        FinishedCombatPlaybackState(
          speed: currentState.speed,
          combatReplay: currentState.combatReplay,
        ),
      );

      return;
    }

    final finalTick = currentState.combatReplay.finalTick;
    final nextTick = min(currentState.currentTick + currentState.speed.multiplier, finalTick);
    emit(currentState.createCopyAdvancedTo(nextTick));
  }
}
