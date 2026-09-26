import '../player.dart';

abstract class PlayerEngine {
  const PlayerEngine();
  Player startingPlayer({required int startingCoins});
  Player afterLostRound(Player player);
}
