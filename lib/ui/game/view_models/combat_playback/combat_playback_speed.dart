enum CombatPlaybackSpeed {
  fast(multiplier: 2),
  normal(multiplier: 1),
  fastest(multiplier: 4);

  final int multiplier;
  const CombatPlaybackSpeed({required this.multiplier});
}
