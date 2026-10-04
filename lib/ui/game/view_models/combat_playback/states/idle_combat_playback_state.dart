part of 'combat_playback_state.dart';

class IdleCombatPlaybackState extends CombatPlaybackState {
  const IdleCombatPlaybackState({required super.speed});

  @override
  IdleCombatPlaybackState createCopyWithSpeed(CombatPlaybackSpeed speed) => IdleCombatPlaybackState(speed: speed);

  @override
  String toString() => 'IdleCombatPlaybackState(${speed.name})';
}
