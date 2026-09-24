import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/player/team_slot/team_slot.dart';
import 'package:going_wild/domain/models/shop/refresh_shop_offers.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';

import '../../../helpers/combat_helpers.dart' show at;
import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void buyOneCopy(PhaseRun phaseRun, Character character) {
  phaseRun.player.shopOffers = [character];
  buyShopOffer(phaseRun, 0);
}

void main() {
  test('buying pays the rarity cost, empties the slot and adds a one-star character', () {
    final phaseRun = phaseRunWith(coins: 10, shopOffers: [cat, cow, null, rabbit]);

    final hasBought = buyShopOffer(phaseRun, 1);

    expect(hasBought, isTrue);
    expect(phaseRun.player.coins, 10 - cow.rarity.coins);
    expect(phaseRun.player.shopOffers, [cat, null, null, rabbit]);
    expect(ownedCharactersOf(phaseRun.player), [(character: cow, stars: 1)]);
  });

  test('records the purchase', () {
    final phaseRun = phaseRunWith(coins: 10, shopOffers: [cat, cow]);

    buyShopOffer(phaseRun, 1);

    final bought = phaseRun.events.whereType<CharacterBought>().single;
    expect(bought.character, cow);
    expect(bought.offerIndex, 1);
    expect(bought.coinsSpent, cow.rarity.coins);
  });

  test('a purchase that completes a pair records the purchase and then the merge', () {
    final phaseRun = phaseRunWith(coins: 10, benchCharacters: [owned(cat)]);

    buyOneCopy(phaseRun, cat);

    expect(phaseRun.events, [isA<CharacterBought>(), isA<CharactersMerged>()]);
  });

  test('buying without enough coins changes nothing', () {
    final phaseRun = phaseRunWith(coins: bull.rarity.coins - 1, shopOffers: [bull]);

    final hasBought = buyShopOffer(phaseRun, 0);

    expect(hasBought, isFalse);
    expect(phaseRun.player.coins, bull.rarity.coins - 1);
    expect(phaseRun.player.shopOffers, [bull]);
    expect(phaseRun.player.ownedCharacters, isEmpty);
    expect(phaseRun.events, isEmpty);
  });

  test('an empty slot cannot be bought', () {
    final phaseRun = phaseRunWith(coins: 10, shopOffers: [null]);
    expect(buyShopOffer(phaseRun, 0), isFalse);
    expect(phaseRun.player.coins, 10);
  });

  test('two copies merge into a two-star character', () {
    final phaseRun = phaseRunWith(coins: 10);

    buyOneCopy(phaseRun, cat);
    buyOneCopy(phaseRun, cat);

    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: 2)]);
  });

  test('four copies merge all the way to max stars', () {
    final phaseRun = phaseRunWith(coins: 20);

    for (var copy = 0; copy < 4; copy++) buyOneCopy(phaseRun, cat);

    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: testShopRules.maxStars)]);
  });

  test('different characters and different stars do not merge', () {
    final phaseRun = phaseRunWith(coins: 10, benchCharacters: [owned(cat, stars: 2)]);

    buyOneCopy(phaseRun, cat);
    buyOneCopy(phaseRun, dog);

    expect(
      ownedCharactersOf(phaseRun.player),
      unorderedEquals([(character: cat, stars: 2), (character: cat, stars: 1), (character: dog, stars: 1)]),
    );
  });

  test('max stars never merge further', () {
    final phaseRun = phaseRunWith(coins: 20, benchCharacters: [owned(cat, stars: testShopRules.maxStars)]);

    for (var copy = 0; copy < 4; copy++) buyOneCopy(phaseRun, cat);

    expect(
      ownedCharactersOf(phaseRun.player),
      unorderedEquals([(character: cat, stars: testShopRules.maxStars), (character: cat, stars: testShopRules.maxStars)]),
    );
  });

  test('once merged to max stars the character leaves the shop from the next refresh on', () {
    final phaseRun = phaseRunWith(coins: 20, level: 10);
    for (var copy = 0; copy < 4; copy++) buyOneCopy(phaseRun, bull);

    for (var refresh = 0; refresh < 200; refresh++) {
      refreshShopOffers(phaseRun);
      expect(phaseRun.player.shopOffers, isNot(contains(bull)));
    }
  });

  test('a bought character goes to the first free bench slot', () {
    final phaseRun = phaseRunWith(coins: 10, benchCharacters: [owned(dog)], shopOffers: [cat]);

    buyShopOffer(phaseRun, 0);

    expect(phaseRun.player.bench[1]!.character, cat);
  });

  test('a full bench refuses a purchase that does not merge', () {
    final phaseRun = phaseRunWith(coins: 10, benchSize: 1, benchCharacters: [owned(dog)], shopOffers: [cat]);

    expect(buyShopOffer(phaseRun, 0), isFalse);
    expect(phaseRun.player.coins, 10);
    expect(phaseRun.player.shopOffers, [cat]);
  });

  test('a full bench accepts a purchase that completes a merge', () {
    final phaseRun = phaseRunWith(coins: 10, benchSize: 1, benchCharacters: [owned(cat)], shopOffers: [cat]);

    expect(buyShopOffer(phaseRun, 0), isTrue);
    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: 2)]);
  });

  test('the merged character takes the place of the copy on the field', () {
    final phaseRun = phaseRunWith(coins: 10, benchCharacters: [owned(dog)], fieldCharacters: {at(6, 2): owned(cat)}, shopOffers: [cat]);

    buyShopOffer(phaseRun, 0);

    expect((phaseRun.player.field[at(6, 2)]!.character, phaseRun.player.field[at(6, 2)]!.stars), (cat, 2));
    expect(phaseRun.player.bench.nonNulls.map((ownedCharacter) => ownedCharacter.character), [dog]);
    expect(phaseRun.events.whereType<CharactersMerged>().single.slot, FieldSlot(position: at(6, 2)));
  });

  test('nothing can be bought once the phase is over', () {
    final phaseRun = phaseRunWith(coins: 10, shopOffers: [cat])..status = PhaseStatus.won;

    expect(buyShopOffer(phaseRun, 0), isFalse);
    expect(phaseRun.player.coins, 10);
    expect(phaseRun.player.ownedCharacters, isEmpty);
    expect(phaseRun.events, isEmpty);
  });
}
