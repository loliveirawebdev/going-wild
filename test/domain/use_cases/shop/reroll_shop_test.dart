import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/shop/refresh_shop_offers.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';

import '../../../helpers/shop_helpers.dart';

void main() {
  test('rerolling costs coins and replaces the offers', () {
    final player = playerWith(coins: 5, level: 6);
    refreshShopOffers(player, testShopRules, Random(1));
    final offersBeforeReroll = [...player.shopOffers];

    final hasRerolled = rerollShop(player, testShopRules, Random(2));

    expect(hasRerolled, isTrue);
    expect(player.coins, 5 - testShopRules.rerollCostInCoins);
    expect(player.shopOffers, hasLength(testShopRules.shopSize));
    expect(player.shopOffers, isNot(offersBeforeReroll));
  });

  test('rerolling without enough coins changes nothing', () {
    final player = playerWith(coins: testShopRules.rerollCostInCoins - 1, level: 6);
    refreshShopOffers(player, testShopRules, Random(1));
    final offersBeforeReroll = [...player.shopOffers];

    final hasRerolled = rerollShop(player, testShopRules, Random(2));

    expect(hasRerolled, isFalse);
    expect(player.coins, testShopRules.rerollCostInCoins - 1);
    expect(player.shopOffers, offersBeforeReroll);
  });
}
