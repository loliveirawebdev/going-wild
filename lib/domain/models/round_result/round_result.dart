class RoundResult {
  const RoundResult({
    required this.livesLost,
    required this.isVictory,
    required this.roundNumber,
    required this.coinsGained,
    required this.experienceGained,
  });

  final int livesLost;
  final bool isVictory;
  final int roundNumber;
  final int coinsGained;
  final int experienceGained;
}
