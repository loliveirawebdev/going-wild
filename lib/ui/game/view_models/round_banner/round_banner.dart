sealed class RoundBanner {
  const RoundBanner();
}

class CountdownRoundBanner extends RoundBanner {
  const CountdownRoundBanner();
}

class ResultRoundBanner extends RoundBanner {
  final int livesLost;
  final bool isVictory;
  final int roundNumber;
  final int coinsGained;
  final int experienceGained;

  const ResultRoundBanner({
    required this.livesLost,
    required this.isVictory,
    required this.roundNumber,
    required this.coinsGained,
    required this.experienceGained,
  });
}
