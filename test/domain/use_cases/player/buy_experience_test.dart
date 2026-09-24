import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/player/buy_experience.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  test('buying experience costs coins and adds experience', () {
    final phaseRun = phaseRunWith(coins: 10, level: 4);

    final hasBought = buyExperience(phaseRun);

    expect(hasBought, isTrue);
    expect(phaseRun.player.coins, 10 - testShopRules.experiencePurchaseCostInCoins);
    expect(phaseRun.player.level, 4);
    expect(phaseRun.player.experience, testShopRules.experiencePerPurchase);
    expect(phaseRun.events.whereType<PlayerReceivedExperience>().single.amount, testShopRules.experiencePerPurchase);
  });

  test('reaching the threshold levels up and keeps the leftover experience', () {
    final phaseRun = phaseRunWith(coins: 10, level: 3, experience: 4);

    buyExperience(phaseRun);

    expect(phaseRun.player.level, 4);
    expect(phaseRun.player.experience, 4 + testShopRules.experiencePerPurchase - testShopRules.playerLevels[2].experienceToNextLevel);
    expect(phaseRun.events.whereType<PlayerLeveledUp>().single.newLevel, 4);
  });

  test('one purchase can go up more than one level', () {
    final phaseRun = phaseRunWith(coins: 10, level: 1);

    buyExperience(phaseRun);

    expect(phaseRun.player.level, 3);
    expect(phaseRun.player.experience, 0);
  });

  test('buying experience without enough coins changes nothing', () {
    final phaseRun = phaseRunWith(coins: testShopRules.experiencePurchaseCostInCoins - 1, level: 4, experience: 3);

    final hasBought = buyExperience(phaseRun);

    expect(hasBought, isFalse);
    expect(phaseRun.player.coins, testShopRules.experiencePurchaseCostInCoins - 1);
    expect(phaseRun.player.experience, 3);
    expect(phaseRun.events, isEmpty);
  });

  test('reaching max level clears the experience', () {
    final lastThreshold = testShopRules.playerLevels[testShopRules.maxLevel - 2].experienceToNextLevel;
    final phaseRun = phaseRunWith(coins: 10, level: testShopRules.maxLevel - 1, experience: lastThreshold - 1);

    buyExperience(phaseRun);

    expect(phaseRun.player.level, testShopRules.maxLevel);
    expect(phaseRun.player.experience, 0);
  });

  test('at max level experience cannot be bought', () {
    final phaseRun = phaseRunWith(coins: 10, level: testShopRules.maxLevel);

    final hasBought = buyExperience(phaseRun);

    expect(hasBought, isFalse);
    expect(phaseRun.player.coins, 10);
  });

  test('no experience can be bought once the phase is over', () {
    final phaseRun = phaseRunWith(coins: 10, level: 4)..status = PhaseStatus.won;

    expect(buyExperience(phaseRun), isFalse);
    expect(phaseRun.player.coins, 10);
    expect(phaseRun.player.experience, 0);
    expect(phaseRun.events, isEmpty);
  });
}
