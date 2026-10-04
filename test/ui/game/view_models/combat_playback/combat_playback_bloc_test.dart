import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/combat/basic_combat_engine.dart';
import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_speed_changed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_started.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';

import '../../../../helpers/manual_combat_playback_clock.dart';
import '../../../../helpers/use_case_helpers.dart';

final ticksPerSecond = basicCombatEngine.rules.ticksPerSecond;

CombatHistory recordedHistory() => basicCombatEngine
    .simulate(
      recordsHistory: true,
      randomGenerator: Random(1),
      team: [placed(bull, 6, 2), placed(cat, 7, 1)],
      enemies: [placed(rat, 1, 2), placed(fox, 1, 3)],
    )
    .history;

Future<void> settle() async {
  for (var turn = 0; turn < 10; turn++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Future<CombatPlaybackBloc> startedPlayback(ManualCombatPlaybackClock clock, {CombatPlaybackSpeed? speed}) async {
  final combatPlaybackBloc = CombatPlaybackBloc(clock: clock);
  if (speed != null) combatPlaybackBloc.add(CombatPlaybackSpeedChanged(speed: speed));

  combatPlaybackBloc.add(CombatPlaybackStarted(combatHistory: recordedHistory(), ticksPerSecond: ticksPerSecond));
  await settle();

  return combatPlaybackBloc;
}

Future<void> playToTheEnd(ManualCombatPlaybackClock clock, CombatPlaybackBloc combatPlaybackBloc) async {
  while (combatPlaybackBloc.state is PlayingCombatPlaybackState) {
    clock.beat();
    await settle();
  }
}

PlayingCombatPlaybackState playingStateOf(CombatPlaybackBloc combatPlaybackBloc) => combatPlaybackBloc.state as PlayingCombatPlaybackState;

void main() {
  late ManualCombatPlaybackClock clock;

  setUp(() => clock = ManualCombatPlaybackClock());

  test('the player waits idle at normal speed', () async {
    final combatPlaybackBloc = CombatPlaybackBloc(clock: clock);

    expect(combatPlaybackBloc.state, isA<IdleCombatPlaybackState>());
    expect(combatPlaybackBloc.state.speed, CombatPlaybackSpeed.normal);

    await combatPlaybackBloc.close();
  });

  test('starting plays from the first tick, beating once per combat tick', () async {
    final combatPlaybackBloc = await startedPlayback(clock);
    final playingState = playingStateOf(combatPlaybackBloc);

    expect(playingState.currentTick, 0);
    expect(playingState.entriesSincePreviousTick, isEmpty);
    expect(clock.requestedIntervals.single, Duration(milliseconds: 1000 ~/ ticksPerSecond));

    await combatPlaybackBloc.close();
  });

  test('every beat advances as many ticks as the speed multiplier', () async {
    final normalPlayback = await startedPlayback(clock);
    clock.beat();
    await settle();
    expect(playingStateOf(normalPlayback).currentTick, 1);
    await normalPlayback.close();

    final fastestClock = ManualCombatPlaybackClock();
    final fastestPlayback = await startedPlayback(fastestClock, speed: CombatPlaybackSpeed.fastest);
    fastestClock.beat();
    await settle();
    expect(playingStateOf(fastestPlayback).currentTick, 4);
    expect(playingStateOf(fastestPlayback).previousTick, 0);
    await fastestPlayback.close();
  });

  test('changing the speed while playing keeps the current tick', () async {
    final combatPlaybackBloc = await startedPlayback(clock);
    clock.beat();
    await settle();

    combatPlaybackBloc.add(const CombatPlaybackSpeedChanged(speed: CombatPlaybackSpeed.fast));
    await settle();
    expect(playingStateOf(combatPlaybackBloc).currentTick, 1);

    clock.beat();
    await settle();
    expect(playingStateOf(combatPlaybackBloc).currentTick, 3);

    await combatPlaybackBloc.close();
  });

  test('the playback finishes one beat after the final tick and stops listening to the clock', () async {
    final combatPlaybackBloc = await startedPlayback(clock);
    final finalTick = playingStateOf(combatPlaybackBloc).combatReplay.finalTick;

    for (var tick = 0; tick < finalTick; tick++) {
      clock.beat();
      await settle();
    }

    expect(playingStateOf(combatPlaybackBloc).currentTick, finalTick);

    clock.beat();
    await settle();
    expect(combatPlaybackBloc.state, isA<FinishedCombatPlaybackState>());

    clock.beat();
    await settle();
    expect(clock.isBeating, isFalse);

    await combatPlaybackBloc.close();
  });

  test('the chosen speed carries over to the next fight and a second start while playing is ignored', () async {
    final combatPlaybackBloc = await startedPlayback(clock, speed: CombatPlaybackSpeed.fast);

    combatPlaybackBloc.add(CombatPlaybackStarted(combatHistory: recordedHistory(), ticksPerSecond: ticksPerSecond));
    await settle();
    expect(clock.requestedIntervals, hasLength(1));

    await playToTheEnd(clock, combatPlaybackBloc);
    combatPlaybackBloc.add(CombatPlaybackStarted(combatHistory: recordedHistory(), ticksPerSecond: ticksPerSecond));
    await settle();

    expect(playingStateOf(combatPlaybackBloc).speed, CombatPlaybackSpeed.fast);
    expect(clock.requestedIntervals, hasLength(2));

    await combatPlaybackBloc.close();
  });
}
