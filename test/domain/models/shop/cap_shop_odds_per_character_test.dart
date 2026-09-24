import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/shop/cap_shop_odds_per_character.dart';

import '../../../helpers/shop_helpers.dart';

final teamCharacterCountByRarity = {
  for (final rarity in Rarity.values) rarity: allTeamCharacters.where((character) => character.rarity == rarity).length,
};

Map<Rarity, double> cappedOddsAtLevel(int level, {Map<Rarity, int>? purchasableCharacterCountByRarity}) => capShopOddsPerCharacter(
  oddsPercentageByRarity: testShopRules.playerLevels[level - 1].shopOddsPercentageByRarity,
  purchasableCharacterCountByRarity: purchasableCharacterCountByRarity ?? teamCharacterCountByRarity,
  maxOddsPercentagePerCharacter: testShopRules.maxShopOddsPercentagePerCharacter,
);

void main() {
  test('odds under the cap stay untouched', () {
    final cappedOdds = capShopOddsPerCharacter(
      oddsPercentageByRarity: {Rarity.common: 75, Rarity.uncommon: 25, Rarity.rare: 0, Rarity.epic: 0},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
      maxOddsPercentagePerCharacter: 15,
    );
    expect(cappedOdds, {Rarity.common: 75, Rarity.uncommon: 25, Rarity.rare: 0, Rarity.epic: 0});
  });

  test('odds above the cap go to the other rarities in proportion, cascading when those hit the cap too', () {
    final cappedOdds = capShopOddsPerCharacter(
      oddsPercentageByRarity: {Rarity.common: 5, Rarity.uncommon: 10, Rarity.rare: 20, Rarity.epic: 65},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
      maxOddsPercentagePerCharacter: 15,
    );
    expect(cappedOdds[Rarity.epic], closeTo(15, 0.001));
    expect(cappedOdds[Rarity.rare], closeTo(45, 0.001));
    expect(cappedOdds[Rarity.uncommon], closeTo(26.667, 0.001));
    expect(cappedOdds[Rarity.common], closeTo(13.333, 0.001));
  });

  test('a rarity with no purchasable characters gives all its odds away', () {
    final cappedOdds = capShopOddsPerCharacter(
      oddsPercentageByRarity: {Rarity.common: 45, Rarity.uncommon: 33, Rarity.rare: 20, Rarity.epic: 2},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 0},
      maxOddsPercentagePerCharacter: 15,
    );
    expect(cappedOdds[Rarity.epic], 0);
    expect(cappedOdds.values.reduce((sum, odds) => sum + odds), closeTo(100, 0.001));
  });

  test('a rarity with zero odds never receives the excess', () {
    final cappedOdds = capShopOddsPerCharacter(
      oddsPercentageByRarity: {Rarity.common: 55, Rarity.uncommon: 30, Rarity.rare: 15, Rarity.epic: 0},
      purchasableCharacterCountByRarity: {Rarity.common: 1, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
      maxOddsPercentagePerCharacter: 15,
    );
    expect(cappedOdds[Rarity.epic], 0);
  });

  test('when nobody can take the excess the capped rarity keeps its odds', () {
    final cappedOdds = capShopOddsPerCharacter(
      oddsPercentageByRarity: {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0},
      purchasableCharacterCountByRarity: {Rarity.common: 5, Rarity.uncommon: 5, Rarity.rare: 3, Rarity.epic: 1},
      maxOddsPercentagePerCharacter: 15,
    );
    expect(cappedOdds, {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0});
  });

  test('with the real team every level still adds up to 100', () {
    for (var level = 1; level <= testShopRules.maxLevel; level++) {
      expect(cappedOddsAtLevel(level).values.reduce((sum, odds) => sum + odds), closeTo(100, 0.001), reason: 'level $level');
    }
  });

  test('with the real team no character goes above the cap from level 3 on', () {
    for (var level = 3; level <= testShopRules.maxLevel; level++) {
      final cappedOdds = cappedOddsAtLevel(level);
      for (final rarity in Rarity.values) {
        final oddsPerCharacter = cappedOdds[rarity]! / teamCharacterCountByRarity[rarity]!;
        expect(
          oddsPerCharacter,
          lessThanOrEqualTo(testShopRules.maxShopOddsPercentagePerCharacter + 0.001),
          reason: 'level $level ${rarity.name}',
        );
      }
    }
  });

  test('with the real team a higher level never offers a cheaper shop on average', () {
    double averageCoinCost(int level) =>
        cappedOddsAtLevel(level).entries.fold(0.0, (sum, entry) => sum + entry.key.coins * entry.value) / 100;

    for (var level = 2; level <= testShopRules.maxLevel; level++) {
      expect(averageCoinCost(level), greaterThanOrEqualTo(averageCoinCost(level - 1)), reason: 'level $level');
    }
    expect(averageCoinCost(testShopRules.maxLevel), greaterThan(averageCoinCost(1)));
  });
}
