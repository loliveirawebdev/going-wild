import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/shop/refresh_shop_offers.dart';

import '../../../helpers/shop_helpers.dart';

List<Character?> offersAfterManyRefreshes(Player player, {int refreshCount = 500, int seed = 1}) {
  final randomGenerator = Random(seed);
  final allOffers = <Character?>[];
  for (var refresh = 0; refresh < refreshCount; refresh++) {
    refreshShopOffers(player, testShopRules, randomGenerator);
    allOffers.addAll(player.shopOffers);
  }
  return allOffers;
}

void main() {
  test('fills every slot of the shop', () {
    final player = playerWith(level: 5);
    refreshShopOffers(player, testShopRules, Random(1));
    expect(player.shopOffers, hasLength(testShopRules.shopSize));
    expect(player.shopOffers, everyElement(isNotNull));
  });

  test('the same seed gives the same shop', () {
    final firstPlayer = playerWith(level: 6);
    final secondPlayer = playerWith(level: 6);
    refreshShopOffers(firstPlayer, testShopRules, Random(42));
    refreshShopOffers(secondPlayer, testShopRules, Random(42));
    expect(firstPlayer.shopOffers, secondPlayer.shopOffers);
  });

  test('level 1 offers only common characters', () {
    final allOffers = offersAfterManyRefreshes(playerWith(level: 1));
    expect(allOffers.map((character) => character!.rarity).toSet(), {Rarity.common});
  });

  test('a rarity with zero odds at the current level never shows up', () {
    final allOffers = offersAfterManyRefreshes(playerWith(level: 4));
    expect(allOffers.where((character) => character!.rarity == Rarity.epic), isEmpty);
  });

  test('rarities show up close to the odds of the level', () {
    const level = 7;
    final allOffers = offersAfterManyRefreshes(playerWith(level: level), refreshCount: 5000);
    final shopOddsPercentageByRarity = testShopRules.playerLevels[level - 1].shopOddsPercentageByRarity;

    for (final rarity in Rarity.values) {
      final observedPercentage = allOffers.where((character) => character!.rarity == rarity).length / allOffers.length * 100;
      expect(observedPercentage, closeTo(shopOddsPercentageByRarity[rarity]!, 1.5), reason: rarity.name);
    }
  });

  test('the bull shows up at most at the per character cap even when epic odds are higher', () {
    const maxOddsPercentagePerCharacter = 5;
    final rulesWithLowCap = shopRulesWith(maxShopOddsPercentagePerCharacter: maxOddsPercentagePerCharacter);
    final player = playerWith(level: rulesWithLowCap.maxLevel);
    final randomGenerator = Random(1);
    final allOffers = <Character?>[];
    for (var refresh = 0; refresh < 5000; refresh++) {
      refreshShopOffers(player, rulesWithLowCap, randomGenerator);
      allOffers.addAll(player.shopOffers);
    }
    final bullPercentage = allOffers.where((character) => character == bull).length / allOffers.length * 100;

    expect(rulesWithLowCap.playerLevels.last.shopOddsPercentageByRarity[Rarity.epic], greaterThan(maxOddsPercentagePerCharacter));
    expect(bullPercentage, closeTo(maxOddsPercentagePerCharacter, 1));
  });

  test('a character owned at max stars stops showing up', () {
    final player = playerWith(level: 10, ownedCharacters: [owned(bull, stars: testShopRules.maxStars)]);
    expect(offersAfterManyRefreshes(player), isNot(contains(bull)));
  });

  test('a character below max stars keeps showing up', () {
    final player = playerWith(level: 10, ownedCharacters: [owned(bull, stars: testShopRules.maxStars - 1)]);
    expect(offersAfterManyRefreshes(player), contains(bull));
  });

  test('when a whole rarity is maxed out its odds go to the other rarities', () {
    final player = playerWith(level: 10, ownedCharacters: [owned(bull, stars: testShopRules.maxStars)]);
    final allOffers = offersAfterManyRefreshes(player);
    expect(allOffers, everyElement(isNotNull));
    expect(allOffers.where((character) => character!.rarity == Rarity.epic), isEmpty);
  });

  test('slots stay empty when nothing is left to offer at the current odds', () {
    final allCommonsAtMaxStars = allTeamCharacters
        .where((character) => character.rarity == Rarity.common)
        .map((character) => owned(character, stars: testShopRules.maxStars))
        .toList();
    final player = playerWith(level: 1, ownedCharacters: allCommonsAtMaxStars);

    refreshShopOffers(player, testShopRules, Random(1));

    expect(player.shopOffers, hasLength(testShopRules.shopSize));
    expect(player.shopOffers, everyElement(isNull));
  });
}
