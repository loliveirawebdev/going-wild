import 'errors/not_enough_coins_error.dart';

class Player {
  const Player({required this.coins, required this.remainingLives});

  final int coins;
  final int remainingLives;

  bool get isOutOfLives => remainingLives <= 0;
  bool canAfford(int costInCoins) => coins >= costInCoins;

  Player createCopyWithCoinsSpent(int costInCoins) {
    if (!canAfford(costInCoins)) throw NotEnoughCoinsError(costInCoins: costInCoins, coins: coins);
    return Player(coins: coins - costInCoins, remainingLives: remainingLives);
  }

  Player createCopyWithCoinsReceived(int coinsAmount) => Player(coins: coins + coinsAmount, remainingLives: remainingLives);
}
