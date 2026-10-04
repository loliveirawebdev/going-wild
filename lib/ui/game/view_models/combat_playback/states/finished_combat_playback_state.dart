part of 'combat_playback_state.dart';

class FinishedCombatPlaybackState extends CombatPlaybackState {
  final CombatReplay combatReplay;
  const FinishedCombatPlaybackState({required super.speed, required this.combatReplay});

  CombatReplayFrame get finalFrame => combatReplay.finalFrame;

  @override
  FinishedCombatPlaybackState createCopyWithSpeed(CombatPlaybackSpeed speed) => FinishedCombatPlaybackState(
    speed: speed,
    combatReplay: combatReplay,
  );

  @override
  String toString() => 'FinishedCombatPlaybackState(${speed.name})';
}
