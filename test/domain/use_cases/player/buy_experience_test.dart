import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/use_cases/player/buy_experience.dart';

import '../../../helpers/shop_helpers.dart';

void main() {
  test('buying experience costs coins and adds experience', () {
    final player = playerWith(coins: 10, level: 4);

    final hasBought = buyExperience(player, testShopRules);

    expect(hasBought, isTrue);
    expect(player.coins, 10 - testShopRules.experiencePurchaseCostInCoins);
    expect(player.level, 4);
    expect(player.experience, testShopRules.experiencePerPurchase);
  });

  test('reaching the threshold levels up and keeps the leftover experience', () {
    final player = playerWith(coins: 10, level: 3, experience: 4);

    buyExperience(player, testShopRules);

    expect(player.level, 4);
    expect(player.experience, 4 + testShopRules.experiencePerPurchase - testShopRules.playerLevels[2].experienceToNextLevel);
  });

  test('one purchase can go up more than one level', () {
    final player = playerWith(coins: 10, level: 1);

    buyExperience(player, testShopRules);

    expect(player.level, 3);
    expect(player.experience, 0);
  });

  test('buying experience without enough coins changes nothing', () {
    final player = playerWith(coins: testShopRules.experiencePurchaseCostInCoins - 1, level: 4, experience: 3);

    final hasBought = buyExperience(player, testShopRules);

    expect(hasBought, isFalse);
    expect(player.coins, testShopRules.experiencePurchaseCostInCoins - 1);
    expect(player.experience, 3);
  });

  test('reaching max level clears the experience', () {
    final lastThreshold = testShopRules.playerLevels[testShopRules.maxLevel - 2].experienceToNextLevel;
    final player = playerWith(coins: 10, level: testShopRules.maxLevel - 1, experience: lastThreshold - 1);

    buyExperience(player, testShopRules);

    expect(player.level, testShopRules.maxLevel);
    expect(player.experience, 0);
  });

  test('at max level experience cannot be bought', () {
    final player = playerWith(coins: 10, level: testShopRules.maxLevel);

    final hasBought = buyExperience(player, testShopRules);

    expect(hasBought, isFalse);
    expect(player.coins, 10);
  });
}
