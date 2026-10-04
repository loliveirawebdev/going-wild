import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/domain/models/economy/engines/basic_economy_engine.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_engines.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/shop/errors/empty_shop_offer_error.dart';
import 'package:going_wild/domain/models/shop/errors/shop_already_locked_error.dart';
import 'package:going_wild/domain/models/shop/errors/shop_already_unlocked_error.dart';

import '../../../helpers/inventory_helpers.dart';
import '../../../helpers/use_case_helpers.dart';

void main() {
  group('buying', () {
    test('buying an offer pays for it, empties the offer and puts the character on the first free inventory slot', () {
      final matchProgress = withShopOffers(startWith([oneRat]), [cat, dog, null, cow]);

      final bought = buyShopOffer(matchProgress, offerIndex: 0);

      expect(bought.player.coins, matchProgress.player.coins - basicEconomyEngine.priceOfRarity(cat.rarity));
      expect(bought.shop.offers, [null, dog, null, cow]);
      expect(bought.playerRoster.inventory.entryAt(0)!.character, cat);
    });

    test('an empty offer, missing coins or a full inventory fail with their own errors', () {
      final matchProgress = withShopOffers(startWith([oneRat]), [cat, null, null, null]);
      final poorMatchProgress = withCoins(matchProgress, 0);
      final fullInventoryMatchProgress = withInventory(matchProgress, [characterCopyOf(dog)], capacity: 1);

      expect(() => buyShopOffer(matchProgress, offerIndex: 1), throwsA(isA<EmptyShopOfferError>()));
      expect(() => buyShopOffer(poorMatchProgress, offerIndex: 0), throwsA(isA<NotEnoughCoinsError>()));
      expect(() => buyShopOffer(fullInventoryMatchProgress, offerIndex: 0), throwsA(isA<InventoryIsFullError>()));
    });

    test('a purchase that completes a merge works even with a full inventory', () {
      final matchProgressWithCatOffer = withShopOffers(startWith([oneRat]), [cat, null, null, null]);
      final matchProgress = withInventory(matchProgressWithCatOffer, [characterCopyOf(cat)], capacity: 1);

      final bought = buyShopOffer(matchProgress, offerIndex: 0);

      expect(bought.playerRoster.inventory.entryAt(0)!.character, cat);
      expect(bought.playerRoster.inventory.entryAt(0)!.stars, 2);
    });

    test('merges cascade: the new two-star joins an existing two-star', () {
      final matchProgressWithCatOffer = withShopOffers(startWith([oneRat]), [cat, null, null, null]);
      final matchProgress = withInventory(matchProgressWithCatOffer, [characterCopyOf(cat, stars: 2), characterCopyOf(cat)]);

      final bought = buyShopOffer(matchProgress, offerIndex: 0);

      final boughtCharacterCopies = bought.playerRoster.inventory.entries.map(
        (characterCopy) => (characterCopy.character, characterCopy.stars),
      );
      expect(boughtCharacterCopies, [(cat, 3)]);
    });

    test('the merged character lands on the board when the first copy is there', () {
      final matchProgressWithCatOffer = withShopOffers(startWith([oneRat]), [cat, null, null, null]);
      final matchProgress = matchProgressWithCatOffer.createCopyWithPlayerPlacements([placed(cat, 6, 2)]);

      final bought = buyShopOffer(matchProgress, offerIndex: 0);

      expect(bought.playerRoster.placements.single.characterCopy.stars, 2);
      expect(bought.playerRoster.placements.single.position, at(6, 2));
      expect(bought.playerRoster.inventory.entries, isEmpty);
    });
  });

  group('the shop', () {
    test('rerolling pays the reroll cost and brings new offers', () {
      final matchProgress = startWith([oneRat]);

      final rerolled = rerollShop(matchProgress);

      expect(rerolled.player.coins, matchProgress.player.coins - basicEconomyEngine.fixedRerollCostInCoins);
      expect(rerolled.shop.offers, everyElement(isNotNull));
    });

    test('the reroll cost comes from the economy engine chosen by the phase', () {
      final expensiveEconomyEngine = BasicEconomyEngine(
        fixedRerollCostInCoins: 7,
        startingCoins: basicEconomyEngine.startingCoins,
        priceInCoinsByRarity: basicEconomyEngine.priceInCoinsByRarity,
        fixedExperiencePerPurchase: basicEconomyEngine.fixedExperiencePerPurchase,
        fixedExperiencePurchaseCostInCoins: basicEconomyEngine.fixedExperiencePurchaseCostInCoins,
        mergedCharacterSellDiscountInCoins: basicEconomyEngine.mergedCharacterSellDiscountInCoins,
      );
      final expensiveRerollEngines = PhaseEngines(
        economyEngine: expensiveEconomyEngine,
        setEngine: basicPhaseEngines.setEngine,
        shopEngine: basicPhaseEngines.shopEngine,
        levelEngine: basicPhaseEngines.levelEngine,
        mergeEngine: basicPhaseEngines.mergeEngine,
        combatEngine: basicPhaseEngines.combatEngine,
        playerEngine: basicPhaseEngines.playerEngine,
        characterEngine: basicPhaseEngines.characterEngine,
        inventoryEngine: basicPhaseEngines.inventoryEngine,
      );
      final expensivePhase = Phase(id: const PhaseId('backyard'), waves: const [oneRat], engines: expensiveRerollEngines);
      final matchProgress = startMatch(expensivePhase, randomGenerator: Random(1));

      final rerolled = rerollShop(matchProgress);

      expect(rerolled.player.coins, matchProgress.player.coins - 7);
    });

    test('rerolling without coins fails', () {
      final matchProgress = withCoins(startWith([oneRat]), 0);
      expect(() => rerollShop(matchProgress), throwsA(isA<NotEnoughCoinsError>()));
    });

    test('locking keeps the offers for the next round and unlocking lets them change', () {
      final poorMatchProgress = withCoins(startWith([oneRat, oneRat]), 0);
      final matchProgress = lockShop(poorMatchProgress.createCopyWithPlayerPlacements(threeStarBullOnBoard));
      final offersBeforeTheFight = matchProgress.shop.offers;

      final nextRound = fightRound(matchProgress, recordsHistory: false).matchProgress;

      expect(nextRound.shop.isLocked, isTrue);
      expect(nextRound.shop.offers, offersBeforeTheFight);
      expect(unlockShop(nextRound).shop.isLocked, isFalse);
    });

    test('characters owned at max stars stop showing up in the shop', () {
      final maxStars = basicCharacterEngine.maxStars;
      final cheapestCharacters = allTeamCharacters.where((character) => basicEconomyEngine.priceOfRarity(character.rarity) == 1);
      final allCommonsAtMaxStars = [for (final character in cheapestCharacters) characterCopyOf(character, stars: maxStars)];
      final matchProgressWithCommons = withInventory(startWith([oneRat]), allCommonsAtMaxStars, capacity: allCommonsAtMaxStars.length);
      final matchProgress = withCoins(matchProgressWithCommons, 100);
      expect(matchProgress.playerLevelProgress.level.number, 2);

      final rerolled = rerollShop(matchProgress);

      expect(rerolled.shop.offers, everyElement(isNull));
    });
  });

  test('locking a locked shop or unlocking an unlocked shop fails', () {
    final matchProgress = startWith([oneRat]);
    expect(() => unlockShop(matchProgress), throwsA(isA<ShopAlreadyUnlockedError>()));
    expect(() => lockShop(lockShop(matchProgress)), throwsA(isA<ShopAlreadyLockedError>()));
  });
}
