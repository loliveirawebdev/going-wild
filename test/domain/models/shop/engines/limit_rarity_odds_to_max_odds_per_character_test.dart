import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/shop/engines/basic_shop_engine.dart';

import '../../../../helpers/shop_helpers.dart';

final teamCharacterCountByRarity = {
  for (final rarity in Rarity.values) rarity: allTeamCharacters.where((character) => character.rarity == rarity).length,
};

final maxLevelNumber = testShopEngine.rarityOddsPercentageByLevelNumber.keys.reduce(max);

Map<Rarity, double> cappedOddsAtLevel(int levelNumber) => limitRarityOddsToMaxOddsPerCharacter(
  purchasableCharacterCountByRarity: teamCharacterCountByRarity,
  maxOddsPercentagePerCharacter: testShopEngine.maxOddsPercentagePerCharacter,
  oddsPercentageByRarity: testShopEngine.rarityOddsPercentageByLevelNumber[levelNumber]!,
);

double totalOddsOf(Map<Rarity, double> oddsByRarity) => oddsByRarity.values.fold(0.0, (sum, odds) => sum + odds);

void main() {
  test('odds under the cap stay untouched', () {
    final cappedOdds = limitRarityOddsToMaxOddsPerCharacter(
      maxOddsPercentagePerCharacter: 15,
      oddsPercentageByRarity: {Rarity.common: 75, Rarity.uncommon: 25, Rarity.rare: 0, Rarity.epic: 0},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
    );
    expect(cappedOdds, {Rarity.common: 75, Rarity.uncommon: 25, Rarity.rare: 0, Rarity.epic: 0});
  });

  test('odds above the cap go to the other rarities in proportion, cascading when those hit the cap too', () {
    final cappedOdds = limitRarityOddsToMaxOddsPerCharacter(
      maxOddsPercentagePerCharacter: 15,
      oddsPercentageByRarity: {Rarity.common: 5, Rarity.uncommon: 10, Rarity.rare: 20, Rarity.epic: 65},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
    );
    expect(cappedOdds[Rarity.epic], closeTo(15, 0.001));
    expect(cappedOdds[Rarity.rare], closeTo(45, 0.001));
    expect(cappedOdds[Rarity.uncommon], closeTo(26.667, 0.001));
    expect(cappedOdds[Rarity.common], closeTo(13.333, 0.001));
  });

  test('a rarity with no purchasable characters gives all its odds away', () {
    final cappedOdds = limitRarityOddsToMaxOddsPerCharacter(
      maxOddsPercentagePerCharacter: 15,
      oddsPercentageByRarity: {Rarity.common: 45, Rarity.uncommon: 33, Rarity.rare: 20, Rarity.epic: 2},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 0},
    );
    expect(cappedOdds[Rarity.epic], 0);
    expect(totalOddsOf(cappedOdds), closeTo(100, 0.001));
  });

  test('a rarity with zero odds never receives the excess', () {
    final cappedOdds = limitRarityOddsToMaxOddsPerCharacter(
      maxOddsPercentagePerCharacter: 15,
      oddsPercentageByRarity: {Rarity.common: 55, Rarity.uncommon: 30, Rarity.rare: 15, Rarity.epic: 0},
      purchasableCharacterCountByRarity: {Rarity.common: 1, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
    );
    expect(cappedOdds[Rarity.epic], 0);
  });

  test('when nobody can take the excess the capped rarity keeps its odds', () {
    final cappedOdds = limitRarityOddsToMaxOddsPerCharacter(
      maxOddsPercentagePerCharacter: 15,
      oddsPercentageByRarity: {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
    );
    expect(cappedOdds, {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0});
  });

  test('with the real team every level still adds up to 100', () {
    for (var levelNumber = 1; levelNumber <= maxLevelNumber; levelNumber++) {
      expect(totalOddsOf(cappedOddsAtLevel(levelNumber)), closeTo(100, 0.001), reason: 'level $levelNumber');
    }
  });

  test('with the real team no character goes above the cap from level 3 on', () {
    for (var levelNumber = 3; levelNumber <= maxLevelNumber; levelNumber++) {
      final cappedOdds = cappedOddsAtLevel(levelNumber);

      for (final rarity in Rarity.values) {
        final oddsPerCharacter = cappedOdds[rarity]! / teamCharacterCountByRarity[rarity]!;
        expect(
          oddsPerCharacter,
          lessThanOrEqualTo(testShopEngine.maxOddsPercentagePerCharacter + 0.001),
          reason: 'level $levelNumber ${rarity.name}',
        );
      }
    }
  });

  test('with the real team a higher level never offers a cheaper shop on average', () {
    double averagePriceInCoinsAtLevel(int levelNumber) {
      final cappedOdds = cappedOddsAtLevel(levelNumber);
      final weightedPriceSum = cappedOdds.entries.fold(
        0.0,
        (sum, entry) => sum + basicEconomyEngine.priceInCoinsByRarity[entry.key]! * entry.value,
      );

      return weightedPriceSum / 100;
    }

    for (var levelNumber = 2; levelNumber <= maxLevelNumber; levelNumber++) {
      final averagePrice = averagePriceInCoinsAtLevel(levelNumber);
      final previousAveragePrice = averagePriceInCoinsAtLevel(levelNumber - 1);

      expect(averagePrice, greaterThanOrEqualTo(previousAveragePrice), reason: 'level $levelNumber');
    }

    expect(averagePriceInCoinsAtLevel(maxLevelNumber), greaterThan(averagePriceInCoinsAtLevel(1)));
  });
}
