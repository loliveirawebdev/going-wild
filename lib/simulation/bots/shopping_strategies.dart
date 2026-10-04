import 'dart:math';

import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/use_cases/level/buy_experience.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_from_inventory.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/simulation/bots/bot_evaluations.dart';

MatchProgress? tryBuying(MatchProgress matchProgress, int offerIndex) {
  final offeredCharacter = matchProgress.shop.offers[offerIndex];
  if (offeredCharacter == null || !matchProgress.player.canAfford(priceOf(matchProgress, offeredCharacter))) return null;

  try {
    return buyShopOffer(matchProgress, offerIndex: offerIndex);
  } on InventoryIsFullError {
    return null;
  }
}

bool canBuyExperience(MatchProgress matchProgress, {int coinsToKeep = 0}) {
  final engines = matchProgress.phase.engines;
  final experienceCost = engines.economyEngine.experiencePurchaseCostInCoins(matchProgress: matchProgress);
  final isMaxLevel = engines.levelEngine.isMaxLevel(matchProgress.playerLevelProgress.level);

  return !isMaxLevel && matchProgress.player.canAfford(experienceCost + coinsToKeep);
}

MatchProgress buyEverything(MatchProgress matchProgress, Random randomGenerator) {
  var shoppingMatchProgress = matchProgress;

  for (var offerIndex = 0; offerIndex < shoppingMatchProgress.shop.offers.length; offerIndex++) {
    shoppingMatchProgress = tryBuying(shoppingMatchProgress, offerIndex) ?? shoppingMatchProgress;
  }

  return shoppingMatchProgress;
}

MatchProgress buyExperienceWhileRich(MatchProgress matchProgress, {required int coinsToKeep}) {
  var levelingMatchProgress = matchProgress;

  while (canBuyExperience(levelingMatchProgress, coinsToKeep: coinsToKeep)) {
    levelingMatchProgress = buyExperience(levelingMatchProgress);
  }

  return levelingMatchProgress;
}

MatchProgress buyEverythingThenExperience(MatchProgress matchProgress, Random randomGenerator) {
  final boughtMatchProgress = buyEverything(matchProgress, randomGenerator);
  return buyExperienceWhileRich(boughtMatchProgress, coinsToKeep: 6);
}

MatchProgress experienceFirstThenEverything(MatchProgress matchProgress, Random randomGenerator) {
  final leveledMatchProgress = buyExperienceWhileRich(matchProgress, coinsToKeep: 0);
  return buyEverything(leveledMatchProgress, randomGenerator);
}

MatchProgress rerollTwiceThenBuyEverything(MatchProgress matchProgress, Random randomGenerator) {
  var rerolledMatchProgress = matchProgress;
  final rerollCostInCoins = matchProgress.phase.engines.economyEngine.rerollCostInCoins(matchProgress: matchProgress);

  for (var reroll = 0; reroll < 2; reroll++) {
    if (!rerolledMatchProgress.player.canAfford(rerollCostInCoins)) break;

    rerolledMatchProgress = rerollShop(rerolledMatchProgress);
  }

  return buyEverythingThenExperience(rerolledMatchProgress, randomGenerator);
}

MatchProgress buyOnly(MatchProgress matchProgress, bool Function(Character character) isWanted) {
  var shoppingMatchProgress = matchProgress;

  for (var offerIndex = 0; offerIndex < shoppingMatchProgress.shop.offers.length; offerIndex++) {
    final offeredCharacter = shoppingMatchProgress.shop.offers[offerIndex];
    if (offeredCharacter == null || !isWanted(offeredCharacter)) continue;

    shoppingMatchProgress = tryBuying(shoppingMatchProgress, offerIndex) ?? shoppingMatchProgress;
  }

  return buyExperienceWhileRich(shoppingMatchProgress, coinsToKeep: 6);
}

MatchProgress buyOnlyCommons(MatchProgress matchProgress, Random randomGenerator) =>
    buyOnly(matchProgress, (character) => character.rarity == Rarity.common);

MatchProgress buyOnlyFrontLiners(MatchProgress matchProgress, Random randomGenerator) => buyOnly(matchProgress, isFrontLiner);

MatchProgress buyOnlyBackLiners(MatchProgress matchProgress, Random randomGenerator) =>
    buyOnly(matchProgress, (character) => !isFrontLiner(character));

MatchProgress buyHalfAtRandom(MatchProgress matchProgress, Random randomGenerator) {
  var shoppingMatchProgress = matchProgress;

  for (var offerIndex = 0; offerIndex < shoppingMatchProgress.shop.offers.length; offerIndex++) {
    if (!randomGenerator.nextBool()) continue;

    shoppingMatchProgress = tryBuying(shoppingMatchProgress, offerIndex) ?? shoppingMatchProgress;
  }

  return shoppingMatchProgress;
}

MatchProgress smartShopping(MatchProgress matchProgress, Random randomGenerator) {
  var shoppingMatchProgress = matchProgress;
  final offers = matchProgress.shop.offers;
  final copiesPerMerge = matchProgress.phase.engines.mergeEngine.copiesPerMerge;

  bool completesAMerge(Character character) {
    final oneStarCopies = ownedCharacterCopiesOf(shoppingMatchProgress).where(
      (characterCopy) => characterCopy.character == character && characterCopy.stars == 1,
    );

    return oneStarCopies.length >= copiesPerMerge - 1;
  }

  final offerIndexes = [
    for (final (index, offeredCharacter) in offers.indexed)
      if (offeredCharacter != null) index,
  ];

  offerIndexes.sort((firstIndex, secondIndex) {
    final firstCharacter = offers[firstIndex]!;
    final secondCharacter = offers[secondIndex]!;
    final mergeOrder = (completesAMerge(secondCharacter) ? 1 : 0).compareTo(completesAMerge(firstCharacter) ? 1 : 0);
    if (mergeOrder != 0) return mergeOrder;

    return priceOf(matchProgress, secondCharacter).compareTo(priceOf(matchProgress, firstCharacter));
  });

  for (final offerIndex in offerIndexes) {
    final offeredCharacter = offers[offerIndex]!;
    final offeredPrice = priceOf(shoppingMatchProgress, offeredCharacter);
    if (!shoppingMatchProgress.player.canAfford(offeredPrice)) continue;

    final boughtMatchProgress = tryBuying(shoppingMatchProgress, offerIndex);

    if (boughtMatchProgress != null) {
      shoppingMatchProgress = boughtMatchProgress;
      continue;
    }

    final weakestBenched = weakestBenchedOf(shoppingMatchProgress);
    if (weakestBenched == null || strengthOf(shoppingMatchProgress, weakestBenched.characterCopy) >= offeredPrice) continue;

    final soldMatchProgress = sellFromInventory(shoppingMatchProgress, inventoryIndex: weakestBenched.index);
    shoppingMatchProgress = tryBuying(soldMatchProgress, offerIndex) ?? soldMatchProgress;
  }

  while (ownedCharacterCopiesOf(shoppingMatchProgress).length > teamSizeOf(shoppingMatchProgress) &&
      canBuyExperience(shoppingMatchProgress)) {
    shoppingMatchProgress = buyExperience(shoppingMatchProgress);
  }

  return shoppingMatchProgress;
}
