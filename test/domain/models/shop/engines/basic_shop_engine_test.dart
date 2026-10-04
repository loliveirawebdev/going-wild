import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/shop/engines/basic_shop_engine.dart';
import 'package:going_wild/domain/models/shop/errors/level_without_shop_odds_error.dart';

import '../../../../helpers/inventory_helpers.dart';
import '../../../../helpers/shop_helpers.dart';
import '../../../../helpers/use_case_helpers.dart';

Roster rosterOwning(Set<Character> characters, {required int stars}) => Roster(
  inventory: inventoryWith(const [], capacity: 0),
  placements: [
    for (final (index, character) in characters.indexed)
      Placement(
        position: at(index ~/ 5, index % 5),
        characterCopy: characterCopyOf(character, stars: stars),
      ),
  ],
);

List<Character?> offersOf({
  required int levelNumber,
  int seed = 1,
  BasicShopEngine engine = testShopEngine,
  Set<Character> ownedAtMaxStars = const {},
}) => engine.pickOffers(
  matchProgress: matchProgressWith(
    seed: seed,
    levelNumber: levelNumber,
    roster: rosterOwning(ownedAtMaxStars, stars: basicCharacterEngine.maxStars),
  ),
);

List<Character?> offersAfterManyPicks({
  required int levelNumber,
  Roster? roster,
  int pickCount = 500,
  BasicShopEngine engine = testShopEngine,
  Set<Character> ownedAtMaxStars = const {},
}) {
  final ownedRoster = roster ?? rosterOwning(ownedAtMaxStars, stars: basicCharacterEngine.maxStars);
  final matchProgress = matchProgressWith(roster: ownedRoster, levelNumber: levelNumber);

  return [for (var pick = 0; pick < pickCount; pick++) ...engine.pickOffers(matchProgress: matchProgress)];
}

Set<Character> allOfRarity(Rarity rarity) => allTeamCharacters.where((character) => character.rarity == rarity).toSet();

void main() {
  test('fills every slot of the shop', () {
    final offers = offersOf(levelNumber: 5);
    expect(offers, hasLength(testShopEngine.size));
    expect(offers, everyElement(isNotNull));
  });

  test('the same seed gives the same shop', () {
    expect(offersOf(seed: 42, levelNumber: 6), offersOf(seed: 42, levelNumber: 6));
  });

  test('level 1 offers only common characters', () {
    final allOffers = offersAfterManyPicks(levelNumber: 1);
    expect(allOffers.map((character) => character!.rarity).toSet(), {Rarity.common});
  });

  test('a rarity with zero odds at the current level never shows up', () {
    final allOffers = offersAfterManyPicks(levelNumber: 4);
    expect(allOffers.where((character) => character!.rarity == Rarity.epic), isEmpty);
  });

  test('rarities show up close to the odds of the level', () {
    const levelNumber = 7;
    final allOffers = offersAfterManyPicks(pickCount: 5000, levelNumber: levelNumber);
    final oddsPercentageByRarity = testShopEngine.rarityOddsPercentageByLevelNumber[levelNumber]!;

    for (final rarity in Rarity.values) {
      final observedPercentage = allOffers.where((character) => character!.rarity == rarity).length / allOffers.length * 100;
      expect(observedPercentage, closeTo(oddsPercentageByRarity[rarity]!, 1.5), reason: rarity.name);
    }
  });

  test('the bull shows up at most at the per character cap even when epic odds are higher', () {
    const maxOddsPercentagePerCharacter = 5;
    final engineWithLowCap = basicShopEngineWith(maxOddsPercentagePerCharacter: maxOddsPercentagePerCharacter);
    final maxLevelNumber = engineWithLowCap.rarityOddsPercentageByLevelNumber.keys.reduce(max);
    final allOffers = offersAfterManyPicks(pickCount: 5000, engine: engineWithLowCap, levelNumber: maxLevelNumber);
    final bullPercentage = allOffers.where((character) => character == bull).length / allOffers.length * 100;

    expect(engineWithLowCap.rarityOddsPercentageByLevelNumber[maxLevelNumber]![Rarity.epic], greaterThan(maxOddsPercentagePerCharacter));
    expect(bullPercentage, closeTo(maxOddsPercentagePerCharacter, 1));
  });

  test('a character owned at max stars never shows up', () {
    expect(offersAfterManyPicks(levelNumber: 10, ownedAtMaxStars: {bull}), isNot(contains(bull)));
  });

  test('a character owned below max stars keeps showing up', () {
    final rosterWithTwoStarBull = rosterOwning({bull}, stars: 2);
    expect(offersAfterManyPicks(levelNumber: 10, roster: rosterWithTwoStarBull), contains(bull));
  });

  test('a character that is not owned keeps showing up', () {
    expect(offersAfterManyPicks(levelNumber: 10), contains(bull));
  });

  test('when a whole rarity is owned at max stars its odds go to the other rarities', () {
    final allOffers = offersAfterManyPicks(levelNumber: 10, ownedAtMaxStars: allOfRarity(Rarity.epic));
    expect(allOffers, everyElement(isNotNull));
    expect(allOffers.where((character) => character!.rarity == Rarity.epic), isEmpty);
  });

  test('slots stay empty when nothing is left to offer at the current odds', () {
    final offers = offersOf(levelNumber: 1, ownedAtMaxStars: allOfRarity(Rarity.common));

    expect(offers, hasLength(testShopEngine.size));
    expect(offers, everyElement(isNull));
  });

  test('the starting shop has every slot empty and is unlocked', () {
    final startingShop = testShopEngine.startingShop();

    expect(startingShop.offers, hasLength(testShopEngine.size));
    expect(startingShop.offers, everyElement(isNull));
    expect(startingShop.isLocked, isFalse);
  });

  test('picking offers for a level without shop odds fails', () {
    expect(() => offersOf(levelNumber: 0), throwsA(isA<LevelWithoutShopOddsError>()));
    final maxLevelNumber = testShopEngine.rarityOddsPercentageByLevelNumber.keys.reduce(max);
    expect(() => offersOf(levelNumber: maxLevelNumber + 1), throwsA(isA<LevelWithoutShopOddsError>()));
  });
}
