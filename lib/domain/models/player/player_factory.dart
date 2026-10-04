import 'package:going_wild/domain/models/player/player.dart';

class PlayerFactory {
  static Player starting({required int coins, required int lives}) => Player(coins: coins, remainingLives: lives);
}
