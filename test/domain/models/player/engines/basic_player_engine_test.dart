import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/player/engines/basic_player_engine.dart';
import 'package:going_wild/domain/models/player/errors/player_has_no_lives_left_error.dart';
import 'package:going_wild/domain/models/player/player.dart';

void main() {
  const playerEngine = BasicPlayerEngine(startingLives: 3, livesLostPerLostRound: 1);

  test('the player starts with the coins and lives of the playerEngine', () {
    final player = playerEngine.startingPlayer(startingCoins: 5);
    expect(player.coins, 5);
    expect(player.remainingLives, 3);
  });

  test('a lost round takes the lives of the playerEngine and keeps the coins', () {
    final player = playerEngine.afterLostRound(playerEngine.startingPlayer(startingCoins: 5));
    expect(player.remainingLives, 2);
    expect(player.coins, 5);
  });

  test('losing a round per life leaves the player out of lives', () {
    var player = playerEngine.startingPlayer(startingCoins: 5);
    for (var lostRound = 0; lostRound < 3; lostRound++) player = playerEngine.afterLostRound(player);
    expect(player.isOutOfLives, isTrue);
  });

  test('a harsher playerEngine takes more lives per lost round', () {
    const harshPlayerEngine = BasicPlayerEngine(startingLives: 3, livesLostPerLostRound: 2);
    expect(harshPlayerEngine.afterLostRound(harshPlayerEngine.startingPlayer(startingCoins: 0)).remainingLives, 1);
  });

  test('losing a round with no lives left fails', () {
    expect(() => playerEngine.afterLostRound(const Player(coins: 0, remainingLives: 0)), throwsA(isA<PlayerHasNoLivesLeftError>()));
  });
}
