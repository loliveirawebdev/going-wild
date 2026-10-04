part of 'combat_playback_state.dart';

class PlayingCombatPlaybackState extends CombatPlaybackState {
  const PlayingCombatPlaybackState({
    required super.speed,
    required this.currentTick,
    required this.previousTick,
    required this.combatReplay,
  });

  final int currentTick;
  final int previousTick;
  final CombatReplay combatReplay;

  bool get isAtFinalTick => currentTick >= combatReplay.finalTick;
  CombatReplayFrame get currentFrame => combatReplay.frameAt(currentTick);

  List<CombatHistoryEntry> get entriesSincePreviousTick => [
    for (var tick = previousTick; tick < currentTick; tick++) ...combatReplay.entriesAt(tick),
  ];

  @useResult
  PlayingCombatPlaybackState createCopyAdvancedTo(int tick) => PlayingCombatPlaybackState(
    speed: speed,
    currentTick: tick,
    previousTick: currentTick,
    combatReplay: combatReplay,
  );

  @override
  PlayingCombatPlaybackState createCopyWithSpeed(CombatPlaybackSpeed speed) => PlayingCombatPlaybackState(
    speed: speed,
    currentTick: currentTick,
    previousTick: previousTick,
    combatReplay: combatReplay,
  );

  @override
  String toString() => 'PlayingCombatPlaybackState(tick: $currentTick/${combatReplay.finalTick}, ${speed.name})';
}
