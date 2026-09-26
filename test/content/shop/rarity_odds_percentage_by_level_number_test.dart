import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/inventory/basic_inventory_engine.dart';
import 'package:going_wild/content/engines/shop/basic_shop_engine.dart';
import 'package:going_wild/content/level/player_levels.dart';
import 'package:going_wild/content/shop/rarity_odds_percentage_by_level_number.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/roster/roster.dart';

void main() {
  final emptyRoster = Roster(placements: const [], inventory: basicCharacterInventoryEngine.emptyInventory());
  final levelNumbers = playerLevels.map((playerLevel) => playerLevel.number).toSet();
  final levelNumbersWithOdds = rarityOddsPercentageByLevelNumber.keys.toSet();

  test('every player level has shop odds', () {
    expect(levelNumbers.difference(levelNumbersWithOdds), isEmpty);
  });

  test('there are no shop odds for a level that does not exist', () {
    expect(levelNumbersWithOdds.difference(levelNumbers), isEmpty);
  });

  test('the shop picks offers at every player level without failing', () {
    for (final levelNumber in levelNumbers) {
      final offers = basicShopEngine.pickOffers(
        roster: emptyRoster,
        levelNumber: levelNumber,
        randomGenerator: Random(1),
        maxStars: basicCharacterEngine.maxStars,
      );
      expect(offers, hasLength(basicShopEngine.size), reason: 'level $levelNumber');
    }
  });

  test('every level lists odds for every rarity and they add up to 100', () {
    for (final MapEntry(key: levelNumber, value: oddsPercentageByRarity) in rarityOddsPercentageByLevelNumber.entries) {
      final totalOdds = oddsPercentageByRarity.values.fold(0, (sum, odds) => sum + odds);

      expect(oddsPercentageByRarity.keys.toSet(), Rarity.values.toSet(), reason: 'level $levelNumber');
      expect(totalOdds, 100, reason: 'level $levelNumber');
    }
  });

  test('level 1 offers only commons', () {
    expect(rarityOddsPercentageByLevelNumber[1]![Rarity.common], 100);
  });

  test('the odds of the best rarity never go down as the level goes up', () {
    final sortedLevelNumbers = levelNumbersWithOdds.toList()..sort();

    for (var index = 1; index < sortedLevelNumbers.length; index++) {
      final levelNumber = sortedLevelNumbers[index];
      final previousOdds = rarityOddsPercentageByLevelNumber[sortedLevelNumbers[index - 1]]![Rarity.epic]!;
      final currentOdds = rarityOddsPercentageByLevelNumber[levelNumber]![Rarity.epic]!;

      expect(currentOdds, greaterThanOrEqualTo(previousOdds), reason: 'level $levelNumber');
    }
  });

  test('every rarity with odds somewhere has a team character to offer', () {
    final raritiesWithOdds = Rarity.values.where(
      (rarity) => rarityOddsPercentageByLevelNumber.values.any((oddsPercentageByRarity) => oddsPercentageByRarity[rarity]! > 0),
    );

    for (final rarity in raritiesWithOdds) {
      expect(allTeamCharacters.where((character) => character.rarity == rarity), isNotEmpty, reason: rarity.name);
    }
  });
}
