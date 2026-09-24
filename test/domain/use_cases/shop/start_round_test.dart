import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/use_cases/shop/start_round.dart';

import '../../../helpers/shop_helpers.dart';

void main() {
  test('a new round pays coins, grants experience and refreshes the shop for free', () {
    final player = playerWith(coins: 3, level: 4);

    startRound(player, testShopRules, Random(1));

    expect(player.coins, 3 + testShopRules.coinsPerRound);
    expect(player.experience, testShopRules.experiencePerRound);
    expect(player.shopOffers, hasLength(testShopRules.shopSize));
    expect(player.shopOffers, everyElement(isNotNull));
  });

  test('the first round takes a new player from level 1 to level 2', () {
    final player = playerWith();

    startRound(player, testShopRules, Random(1));

    expect(player.level, 2);
    expect(player.experience, 0);
  });

  test('bought slots come back filled on the next round', () {
    final player = playerWith(level: 3)..shopOffers = [null, null, null, null];

    startRound(player, testShopRules, Random(1));

    expect(player.shopOffers, everyElement(isNotNull));
  });
}
