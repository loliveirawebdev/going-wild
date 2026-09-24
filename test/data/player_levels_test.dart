import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/characters/team/team.dart';
import 'package:going_wild/data/player_levels.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  test('every level lists odds for every rarity and they add up to 100', () {
    for (final (index, playerLevel) in playerLevels.indexed) {
      expect(playerLevel.shopOddsPercentageByRarity.keys.toSet(), Rarity.values.toSet(), reason: 'level ${index + 1}');
      expect(playerLevel.shopOddsPercentageByRarity.values.reduce((sum, odds) => sum + odds), 100, reason: 'level ${index + 1}');
    }
  });

  test('level 1 offers only commons', () {
    expect(playerLevels.first.shopOddsPercentageByRarity[Rarity.common], 100);
  });

  test('the odds of the best rarity never go down as the level goes up', () {
    for (var level = 1; level < playerLevels.length; level++) {
      final previousOdds = playerLevels[level - 1].shopOddsPercentageByRarity[Rarity.epic]!;
      final currentOdds = playerLevels[level].shopOddsPercentageByRarity[Rarity.epic]!;
      expect(currentOdds, greaterThanOrEqualTo(previousOdds), reason: 'level ${level + 1}');
    }
  });

  test('each level costs at least as much experience as the one before', () {
    final thresholdsBeforeMaxLevel = playerLevels
        .take(playerLevels.length - 1)
        .map((playerLevel) => playerLevel.experienceToNextLevel)
        .toList();
    expect(thresholdsBeforeMaxLevel, everyElement(greaterThan(0)));
    for (var index = 1; index < thresholdsBeforeMaxLevel.length; index++) {
      expect(thresholdsBeforeMaxLevel[index], greaterThanOrEqualTo(thresholdsBeforeMaxLevel[index - 1]));
    }
  });

  test('every rarity with odds somewhere has a team character to offer', () {
    final raritiesWithOdds = Rarity.values.where(
      (rarity) => playerLevels.any((playerLevel) => playerLevel.shopOddsPercentageByRarity[rarity]! > 0),
    );
    for (final rarity in raritiesWithOdds) {
      expect(allTeamCharacters.where((character) => character.rarity == rarity), isNotEmpty, reason: rarity.name);
    }
  });
}
