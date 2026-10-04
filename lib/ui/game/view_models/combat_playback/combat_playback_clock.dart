abstract class CombatPlaybackClock {
  const CombatPlaybackClock();
  Stream<void> beatEvery(Duration interval);
}

class PeriodicCombatPlaybackClock extends CombatPlaybackClock {
  const PeriodicCombatPlaybackClock();

  @override
  Stream<void> beatEvery(Duration interval) => Stream<void>.periodic(interval);
}
