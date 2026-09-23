class BattleRules {
  const BattleRules({
    required this.manaPerHit,
    required this.maxSeconds,
    required this.tickSeconds,
    required this.nearbyRadius,
    required this.lowHealthTriggerPercentage,
  });

  final int manaPerHit;
  final int nearbyRadius;
  final double maxSeconds;
  final double tickSeconds;
  final int lowHealthTriggerPercentage;
}
