import '../errors/player_has_no_lives_left_error.dart';
import '../player.dart';
import '../player_factory.dart';
import 'player_engine.dart';

class BasicPlayerEngine extends PlayerEngine {
  const BasicPlayerEngine({required this.startingLives, required this.livesLostPerLostRound});

  final int startingLives;
  final int livesLostPerLostRound;

  @override
  Player startingPlayer({required int startingCoins}) => PlayerFactory.starting(coins: startingCoins, lives: startingLives);

  @override
  Player afterLostRound(Player player) {
    if (player.isOutOfLives) throw PlayerHasNoLivesLeftError();
    return Player(coins: player.coins, remainingLives: player.remainingLives - livesLostPerLostRound);
  }
}
