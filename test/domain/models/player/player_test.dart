import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/player/player.dart';

void main() {
  const player = Player(coins: 10, remainingLives: 3);

  test('spending and receiving change only the coins', () {
    expect(player.createCopyWithCoinsSpent(4).coins, 6);
    expect(player.createCopyWithCoinsReceived(5).coins, 15);
    expect(player.createCopyWithCoinsSpent(4).remainingLives, 3);
  });

  test('the player can afford what costs up to the coins it has', () {
    expect(player.canAfford(10), isTrue);
    expect(player.canAfford(11), isFalse);
  });

  test('the player is out of lives only when no life remains', () {
    expect(player.isOutOfLives, isFalse);
    expect(const Player(coins: 0, remainingLives: 0).isOutOfLives, isTrue);
  });

  test('changing the player never changes the original', () {
    final _ = player.createCopyWithCoinsSpent(10).createCopyWithCoinsReceived(3);
    expect(player.coins, 10);
    expect(player.remainingLives, 3);
  });

  test('spending more coins than the player has fails', () {
    expect(() => player.createCopyWithCoinsSpent(11), throwsA(isA<NotEnoughCoinsError>()));
  });
}
