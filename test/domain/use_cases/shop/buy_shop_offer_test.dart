import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/characters/team/team.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/shop/refresh_shop_offers.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';

import '../../../helpers/shop_helpers.dart';

void buyOneCopy(Player player, Character character) {
  player.shopOffers = [character];
  buyShopOffer(player, testShopRules, 0);
}

void main() {
  test('buying pays the rarity cost, empties the slot and adds a one-star character', () {
    final player = playerWith(coins: 10)..shopOffers = [cat, cow, null, rabbit];

    final hasBought = buyShopOffer(player, testShopRules, 1);

    expect(hasBought, isTrue);
    expect(player.coins, 10 - cow.rarity.coins);
    expect(player.shopOffers, [cat, null, null, rabbit]);
    expect(ownedCharactersOf(player), [(character: cow, stars: 1)]);
  });

  test('buying without enough coins changes nothing', () {
    final player = playerWith(coins: bull.rarity.coins - 1)..shopOffers = [bull];

    final hasBought = buyShopOffer(player, testShopRules, 0);

    expect(hasBought, isFalse);
    expect(player.coins, bull.rarity.coins - 1);
    expect(player.shopOffers, [bull]);
    expect(player.ownedCharacters, isEmpty);
  });

  test('an empty slot cannot be bought', () {
    final player = playerWith(coins: 10)..shopOffers = [null];
    expect(buyShopOffer(player, testShopRules, 0), isFalse);
    expect(player.coins, 10);
  });

  test('two copies merge into a two-star character', () {
    final player = playerWith(coins: 10);

    buyOneCopy(player, cat);
    buyOneCopy(player, cat);

    expect(ownedCharactersOf(player), [(character: cat, stars: 2)]);
  });

  test('four copies merge all the way to max stars', () {
    final player = playerWith(coins: 20);

    for (var copy = 0; copy < 4; copy++) buyOneCopy(player, cat);

    expect(ownedCharactersOf(player), [(character: cat, stars: testShopRules.maxStars)]);
  });

  test('different characters and different stars do not merge', () {
    final player = playerWith(coins: 10, ownedCharacters: [owned(cat, stars: 2)]);

    buyOneCopy(player, cat);
    buyOneCopy(player, dog);

    expect(
      ownedCharactersOf(player),
      unorderedEquals([(character: cat, stars: 2), (character: cat, stars: 1), (character: dog, stars: 1)]),
    );
  });

  test('max stars never merge further', () {
    final player = playerWith(coins: 20, ownedCharacters: [owned(cat, stars: testShopRules.maxStars)]);

    for (var copy = 0; copy < 4; copy++) buyOneCopy(player, cat);

    expect(
      ownedCharactersOf(player),
      unorderedEquals([(character: cat, stars: testShopRules.maxStars), (character: cat, stars: testShopRules.maxStars)]),
    );
  });

  test('once merged to max stars the character leaves the shop from the next refresh on', () {
    final player = playerWith(coins: 20, level: 10);
    for (var copy = 0; copy < 4; copy++) buyOneCopy(player, bull);

    final randomGenerator = Random(1);
    for (var refresh = 0; refresh < 200; refresh++) {
      refreshShopOffers(player, testShopRules, randomGenerator);
      expect(player.shopOffers, isNot(contains(bull)));
    }
  });
}
