class CombatRules {
  const CombatRules({
    required this.manaPerHit,
    required this.maxSeconds,
    required this.ticksPerSecond,
    required this.nearbyRadius,
  });

  final int manaPerHit;
  final int nearbyRadius;
  final double maxSeconds;
  final int ticksPerSecond;

  double get tickSeconds => 1 / ticksPerSecond;

  int convertSecondsToTicks(double seconds) => (seconds * ticksPerSecond).round();
  int ticksBetweenActions(double actionsPerSecond) => (ticksPerSecond / actionsPerSecond).ceil();
}
