class CombatRules {
  const CombatRules({
    required this.manaPerHit,
    required this.maxSeconds,
    required this.ticksPerSecond,
    required this.nearbyRadius,
    required this.stepSecondsAtBaseMoveSpeed,
    required this.moveSpeedWeightOnSteps,
  });

  final int manaPerHit;
  final int nearbyRadius;
  final double maxSeconds;
  final int ticksPerSecond;
  final double stepSecondsAtBaseMoveSpeed;
  final double moveSpeedWeightOnSteps;

  double get tickSeconds => 1 / ticksPerSecond;

  int convertSecondsToTicks(double seconds) => (seconds * ticksPerSecond).round();
  int ticksBetweenActions(double actionsPerSecond) => (ticksPerSecond / actionsPerSecond).ceil();
  int ticksBetweenSteps(double moveSpeed) {
    final weightedMoveSpeed = 1 + (moveSpeed - 1) * moveSpeedWeightOnSteps;
    return (ticksPerSecond * stepSecondsAtBaseMoveSpeed / weightedMoveSpeed).ceil();
  }
}
